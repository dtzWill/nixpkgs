{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, pkgconfig, libxml2, glib, pipewire, fontconfig, flatpak, gsettings-desktop-schemas, acl, dbus, fuse, geoclue2, json-glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal";
  version = "1.5.0";

  outputs = [ "out" "installedTests" ];

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1iq6hfrq6sa5vwyv2mw02kxjhhkzrlw1rps5saib2hzi5mmwcka0";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit flatpak;
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig libxml2 wrapGAppsHook ];
  buildInputs = [ glib pipewire fontconfig flatpak acl dbus geoclue2 fuse gsettings-desktop-schemas json-glib ];

  doCheck = true; # XXX: investigate!

  configureFlags = [
    "--enable-installed-tests"
  ];

  makeFlags = [
    "installed_testdir=$(installedTests)/libexec/installed-tests/xdg-desktop-portal"
    "installed_test_metadir=$(installedTests)/share/installed-tests/xdg-desktop-portal"
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
