{ stdenv, fetchFromGitHub, cmake, ninja, pkgconfig, intltool, vala, wrapGAppsHook, gcr, libpeas
, gtk3, webkitgtk, sqlite, gsettings-desktop-schemas, libsoup, glib-networking
}:

stdenv.mkDerivation rec {
  pname = "midori";
  version = "9.0";

  src = fetchFromGitHub {
    owner = "midori-browser";
    repo = "core";
    rev = "v${version}";
    sha256 = "18jd8bm33070x4b70nagkmfyx3q61crxxs4d95m490ak8w1g3bz2";
  };

  nativeBuildInputs = [
    pkgconfig cmake ninja intltool vala wrapGAppsHook
  ];

  buildInputs = [
    gtk3 webkitgtk sqlite gsettings-desktop-schemas gcr
    (libsoup.override { gnomeSupport = true; }) libpeas
    glib-networking
  ];

  meta = with stdenv.lib; {
    description = "Lightweight WebKitGTK+ web browser";
    homepage = https://www.midori-browser.org/;
    license = with licenses; [ lgpl21Plus ];
    platforms = with platforms; linux;
    maintainers = with maintainers; [ raskin ramkromberg ];
  };
}
