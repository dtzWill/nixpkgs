{ stdenv, fetchurl, fetchFromGitHub, substituteAll, gtk-doc, pkgconfig, gobject-introspection, intltool
, libgudev, polkit, libxmlb, gusb, sqlite, libarchive, glib-networking
, libsoup, help2man, gpgme, libxslt, elfutils, libsmbios, efivar, glibcLocales
, gnu-efi, libyaml, valgrind, meson, libuuid, colord, docbook_xml_dtd_43, docbook_xsl
, ninja, gcab, gnutls, python3, wrapGAppsHook, json-glib, bash-completion
, shared-mime-info, umockdev, vala, makeFontsConf, freefont_ttf
, cairo, freetype, fontconfig, pango
, bubblewrap, efibootmgr, flashrom, tpm2-tools
, plymouth /* offline */
, diffutils
}:

# Updating? Keep $out/etc synchronized with passthru.filesInstalledToEtc

let
  python = python3.withPackages (p: with p; [ pygobject3 pycairo pillow ]);
  installedTestsPython = python3.withPackages (p: with p; [ pygobject3 requests ]);

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in stdenv.mkDerivation rec {
  pname = "fwupd";
  version = "1.2.9";

  #src = fetchFromGitHub {
  #  owner = "hughsie";
  #  repo = pname;
  #  rev = "0156b8fa7884bc1f8614de68be01a4a3afd98956";
  #  sha256 = "0h3qhamzsc8vhznqkjckzwn3ch3jcvr3zymvslj42j8nqx1ipkq2";
  #};
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "180x706hg7v4myggsz4q3vfxc1z2akwb48bkcn6al665lf2xzzk5";
  };

  outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

  nativeBuildInputs = [
    meson ninja gtk-doc pkgconfig gobject-introspection intltool glibcLocales shared-mime-info
    valgrind gcab docbook_xml_dtd_43 docbook_xsl help2man libxslt python wrapGAppsHook vala
  ];
  buildInputs = [
    polkit libxmlb gusb sqlite libarchive libsoup elfutils libsmbios gnu-efi libyaml
    libgudev colord gpgme libuuid gnutls glib-networking efivar json-glib umockdev
    bash-completion cairo freetype fontconfig pango
  ];

  LC_ALL = "C.UTF-8"; # For po/make-images

  patches = [
    ./fix-paths.patch
    ./add-option-for-installation-sysconfdir.patch

    # installed tests are installed to different output
    # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle
    (substituteAll {
      src = ./installed-tests-path.patch;
      # needs a different set of modules than po/make-images
      inherit installedTestsPython;
    })
  ];

  postPatch = ''
    patchShebangs .

    # we cannot use placeholder in substituteAll
    # https://github.com/NixOS/nix/issues/1846
    substituteInPlace data/installed-tests/meson.build --subst-var installedTests

    # install plug-ins to out, they are not really part of the library
    substituteInPlace meson.build \
      --replace "plugin_dir = join_paths(libdir, 'fwupd-plugins-3')" \
                "plugin_dir = join_paths('${placeholder "out"}', 'fwupd_plugins-3')"

    substituteInPlace plugins/flashrom/fu-plugin-flashrom.c --replace \
      'find_program_in_path ("flashrom"' \
      'find_program_in_path ("${flashrom}/bin/flashrom"'

    substituteInPlace src/fu-offline.c --replace '"plymouth"' '"${plymouth}/bin/plymouth"'

    substituteInPlace plugins/uefi/fu-plugin-uefi.c \
      --replace 'fu_common_find_program_in_path ("efibootmgr"' \
                'fu_common_find_program_in_path ("${efibootmgr}/bin/efibootmgr"' \
      --replace 'g_spawn_command_line_sync ("efibootmgr -v"' \
                'g_spawn_command_line_sync ("${efibootmgr}/bin/efibootmgr -v"'

    substituteInPlace plugins/uefi/fu-uefi-pcrs.c --replace \
      'fu_common_find_program_in_path ("tpm2_pcrlist"' \
      'fu_common_find_program_in_path ("${tpm2-tools}/bin/tpm2_pcrlist"'

    substituteInPlace src/fu-common.c --replace \
      'fu_common_find_program_in_path ("bwrap"' \
      'fu_common_find_program_in_path ("${bubblewrap}/bin/bwrap"'

    substituteInPlace src/fu-test.c \
      --replace '("diff -urNp' \
                '("${diffutils}/bin/diff -urNp'

    substituteInPlace data/meson.build --replace \
      "install_dir: systemd.get_pkgconfig_variable('systemdshutdowndir')" \
      "install_dir: '${placeholder "out"}/lib/systemd/system-shutdown'"
  '';

  # /etc/os-release not available in sandbox
  # doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
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
  };

  meta = with stdenv.lib; {
    homepage = https://fwupd.org/;
    maintainers = with maintainers; [];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
