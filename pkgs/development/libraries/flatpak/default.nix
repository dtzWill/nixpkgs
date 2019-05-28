{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, docbook_xml_dtd_412, docbook_xml_dtd_42, docbook_xml_dtd_43, docbook_xsl, which, libxml2
, gobject-introspection, gtk-doc, intltool, libxslt, pkgconfig, xmlto, appstream-glib, substituteAll, glibcLocales, yacc, xdg-dbus-proxy, p11-kit
, bubblewrap, bzip2, dbus, glib, gpgme, json-glib, libarchive, libcap, libseccomp, coreutils, gettext, python2, hicolor-icon-theme
, libsoup, lzma, ostree, polkit, python3, systemd, xorg, valgrind, glib-networking, wrapGAppsHook, gnome3, gsettings-desktop-schemas, fuse }:

stdenv.mkDerivation rec {
  pname = "flatpak";
  version = "1.4.0";

  # TODO: split out lib once we figure out what to do with triggerdir
  outputs = [ "out" /* "man" "doc" */ "installedTests" ];

  #src = fetchFromGitHub {
  #  owner = pname;
  #  repo = pname;
  #  rev = "7a5c0246954566e4e7516b26beced10762290241";
  #  sha256 = "09mdc6k0nnslr4vjpagarl2074qsi1a18i65vrf6xgdgilya0f04";
  #  fetchSubmodules = true;
  #};
  src = fetchurl {
    url = "https://github.com/flatpak/flatpak/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1zv8flnkmj13c8ak3p60h5ys6v4dz9wapc5pwrn23qvl5r7z1kw2";
  };

  patches = [
    (substituteAll {
      src = ./fix-test-paths.patch;
      inherit coreutils gettext glibcLocales;
      hicolorIconTheme = hicolor-icon-theme;
    })
    (substituteAll {
      src = ./fix-paths.patch;
      p11 = p11-kit;
    })
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
    # patch taken from gtk_doc
    ./respect-xml-catalog-files-var.patch
    ./use-flatpak-from-path.patch
    ./unset-env-vars.patch
  ];

  autoreconfPhase = '':'';

  nativeBuildInputs = [
    autoreconfHook libxml2 docbook_xml_dtd_412 docbook_xml_dtd_42 docbook_xml_dtd_43 docbook_xsl which gobject-introspection
    gtk-doc intltool libxslt pkgconfig xmlto appstream-glib yacc wrapGAppsHook
  ];

  buildInputs = [
    bubblewrap bzip2 dbus gnome3.dconf glib gpgme json-glib libarchive libcap libseccomp
    libsoup lzma ostree polkit python3 systemd xorg.libXau
    gsettings-desktop-schemas glib-networking
    fuse
  ];

  checkInputs = [ valgrind ];

  doCheck = false; # TODO: some issues with temporary files

  NIX_LDFLAGS = [
    "-lpthread"
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-system-bubblewrap=${bubblewrap}/bin/bwrap"
    "--with-system-dbus-proxy=${xdg-dbus-proxy}/bin/xdg-dbus-proxy"
    "--localstatedir=/var"
    "--enable-installed-tests"
    "--disable-documentation"
    "--with-system-helper-user=flatpak"
  ];

  # Uses pthread_sigmask but doesn't link to pthread
  # NIX_CFLAGS_LINK = [ "-lpthread" ];

  makeFlags = [
    "installed_testdir=$(installedTests)/libexec/installed-tests/flatpak"
    "installed_test_metadir=$(installedTests)/share/installed-tests/flatpak"
  ];

  postPatch = ''
    patchShebangs buildutil
    patchShebangs tests
  '';

  meta = with stdenv.lib; {
    description = "Linux application sandboxing and distribution framework";
    homepage = https://flatpak.org/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
