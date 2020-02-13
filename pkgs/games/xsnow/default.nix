{ stdenv, fetchurl, pkgconfig, wrapGAppsHook, libXt, libXpm, libXext, libxml2, gtk3, dbus }:

stdenv.mkDerivation rec {

  version = "2.0.17";
  name = "xsnow-${version}";

  src = fetchurl {
    url = "https://www.ratrabbit.nl/ratrabbit/system/files/xsnow/xsnow-${version}.tar.gz";
    sha256 = "07vly29k4flz0k5fp35i3j7abi7jbi4w5k7zxf3xa7ihy3sfdk5h";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    libXt libXpm libXext
    libxml2 gtk3
    dbus
  ];

  meta = {
    description = "Snow on your desktop";
    homepage = "https://www.ratrabbit.nl/ratrabbit/content/xsnow/introduction";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.robberer ];
  }; 
}
