{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, libxml2
, xdg-desktop-portal
, gtk3
, glib
, wrapGAppsHook
, gsettings-desktop-schemas
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-gtk";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "flatpak";
    repo = pname;
    rev = version;
    sha256 = "1738ndwglj2v69s9xw7qg2bs3dmplfgzygv3dmzwk3gi8nyyg1ps";
  };

  nativeBuildInputs = [
    autoreconfHook
    libxml2
    pkgconfig
    wrapGAppsHook
    xdg-desktop-portal
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  meta = with stdenv.lib; {
    description = "Desktop integration portals for sandboxed apps";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
