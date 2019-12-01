{ stdenv, fetchurl, fetchFromGitHub, substituteAll, gtk-doc, pkgconfig, gobject-introspection, intltool
, libgudev, polkit, libxmlb, gusb, sqlite, libarchive, glib-networking
, libsoup, help2man, gpgme, libxslt, elfutils, libsmbios, efivar, gnu-efi
, libyaml, valgrind, meson, libuuid, docbook_xml_dtd_43, docbook_xsl
, ninja, gcab, gnutls, python3, wrapGAppsHook, json-glib, bash-completion
, shared-mime-info, umockdev, vala, makeFontsConf, freefont_ttf
, cairo, freetype, fontconfig, pango
, bubblewrap, efibootmgr, flashrom, tpm2-tss
, plymouth /* offline */
, diffutils
, nixosTests
, which
}:

let
  python = python3.withPackages (p: with p; [
    pygobject3
    pycairo
    pillow
    setuptools
  ]);

  installedTestsPython = python3.withPackages (p: with p; [ pygobject3 requests ]);

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  isx86 = stdenv.isx86_64 || stdenv.isi686;

  # Dell isn't supported on Aarch64
  haveDell = isx86;

  # only redfish for x86_64
  haveRedfish = stdenv.isx86_64;

  # Currently broken on Aarch64
  haveFlashrom = isx86;

in stdenv.mkDerivation rec {
  pname = "fwupd";
  version = "1.3.5";
  #version = "unstable-2019-11-15";

  #src = fetchFromGitHub {
  #  owner = pname;
  #  repo = pname;
  #  rev = "3d45e693cc4c8c302f2965b7468cacfbe8a385f5";
  #  sha256 = "02wq7893753pn4f6yh6dlbl2q1gik982n34ww5q9zh7s63r8ig1h";
  #};
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "1x2bkhwx0lisbv9ssh4af5x3jp095xgl84966wbzqcjzshw62dg3";
  };

  outputs = [ "out" /* "lib" */ "dev" "man" "installedTests" ];

  nativeBuildInputs = [
    meson ninja pkgconfig gobject-introspection intltool shared-mime-info
    valgrind gcab help2man python wrapGAppsHook vala which
  ];

  buildInputs = [
    polkit libxmlb gusb sqlite libarchive libsoup elfutils gnu-efi libyaml
    libgudev gpgme libuuid gnutls glib-networking json-glib umockdev
    bash-completion cairo freetype fontconfig pango efivar tpm2-tss
  ] ++ stdenv.lib.optionals haveDell [ libsmbios ];

  LC_ALL = "C.UTF-8"; # For po/make-images

  patches = [
    ./fix-paths.patch
    ./add-option-for-installation-sysconfdir.patch
    ./sysconfdir-install.patch

    # installed tests are installed to different output
    # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle
    (substituteAll {
      src = ./installed-tests-path.patch;
      # needs a different set of modules than po/make-images
      inherit installedTestsPython;
    })
  ];

  postPatch = ''
    patchShebangs \
      contrib/get-version.py \
      contrib/generate-version-script.py \
      meson_post_install.sh \
      po/make-images \
      po/make-images.sh \
      po/test-deps

    # we cannot use placeholder in substituteAll
    # https://github.com/NixOS/nix/issues/1846
    substituteInPlace data/installed-tests/meson.build --subst-var installedTests

    # install plug-ins to out, they are not really part of the library
    substituteInPlace meson.build \
      --replace "plugin_dir = join_paths(libdir, 'fwupd-plugins-3')" \
                "plugin_dir = join_paths('${placeholder "out"}', 'fwupd_plugins-3')"

    substituteInPlace src/fu-offline.c --replace '"plymouth"' '"${plymouth}/bin/plymouth"'

    substituteInPlace libfwupdplugin/fu-common.c --replace \
      'fu_common_find_program_in_path ("bwrap"' \
      'fu_common_find_program_in_path ("${bubblewrap}/bin/bwrap"'

    for x in \
      libfwupd/fwupd-self-test.c \
      src/fu-self-test.c \
      plugins/dfu/dfu-self-test.c \
    ; do
      substituteInPlace $x \
        --replace '("diff -urNp' \
                  '("${diffutils}/bin/diff -urNp'
    done

    substituteInPlace data/meson.build --replace \
      "install_dir: systemd.get_pkgconfig_variable('systemdshutdowndir')" \
      "install_dir: '${placeholder "out"}/lib/systemd/system-shutdown'" \
      \
      --replace "subdir('builder')" ""

    substituteInPlace meson.build --replace \
      "systemd.get_pkgconfig_variable('systemdsystempresetdir')" \
      "'${placeholder "out"}/lib/systemd/system-preset'"

    echo '#!/bin/sh' > meson_post_install.sh
    chmod +x meson_post_install.sh
  '';

  # /etc/os-release not available in sandbox
  # doCheck = true;

  preFixup = let
    binPath = [ efibootmgr bubblewrap ] ++ stdenv.lib.optional haveFlashrom flashrom;
  in
  ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      # See programs reached with fu_common_find_program_in_path in source
      --prefix PATH : "${stdenv.lib.makeBinPath binPath}"
    )
  '';

  mesonFlags = [
    "-Dplugin_dummy=true"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-ldsdir=${gnu-efi}/lib"
    "-Defi-includedir=${gnu-efi}/include/efi"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
  ] ++ stdenv.lib.optionals (!haveDell) [
    "-Dplugin_dell=false"
    "-Dplugin_synaptics=false"
  ] ++ stdenv.lib.optionals (!haveRedfish) [
    "-Dplugin_redfish=false"
  ] ++ stdenv.lib.optionals (!haveFlashrom) [
    "-Dplugin_flashrom=false"
  ];

  # TODO: We need to be able to override the directory flags from meson setup hook
  # better – declaring them multiple times might become an error.
  preConfigure = ''
    mesonFlagsArray+=("--libexecdir=$out/libexec")
  '';

  postInstall = ''
    moveToOutput share/installed-tests "$installedTests"
    wrapProgram $installedTests/share/installed-tests/fwupd/hardware.py \
      --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0:${libsoup}/lib/girepository-1.0"
  '';

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  # error: “PolicyKit files are missing”
  # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
  PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";

  # TODO: wrapGAppsHook wraps efi capsule even though it is not elf
  dontWrapGApps = true;
  # so we need to wrap the executables manually
  postFixup = ''
    find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "''${file}" != *.efi ]]; then
        echo "Wrapping program ''${file}"
        wrapProgram "''${file}" "''${gappsWrapperArgs[@]}"
      fi
    done
  '';

  # /etc/fwupd/uefi.conf is created by the services.hardware.fwupd NixOS module
  passthru = {
    filesInstalledToEtc = [
      "fwupd/remotes.d/dell-esrt.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "fwupd/remotes.d/vendor-directory.conf"
      "pki/fwupd/GPG-KEY-Hughski-Limited"
      "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
      "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd-metadata/LVFS-CA.pem"
    ];

    tests = {
      installedTests = nixosTests.fwupd;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://fwupd.org/;
    maintainers = with maintainers; [ jtojnar ];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
