{ stdenv, lib, fetchFromGitHub, pkgconfig, glib, procps, libxml2 }:

stdenv.mkDerivation rec {
  pname = "dbus-map";
  version = "2019-09-22";
  src = fetchFromGitHub {
    owner = "taviso";
    repo = "dbusmap";
    rev = "6bb2831d0ce0443e2ccc33f9493716d731c11937";
    sha256 = "0g42pgcvv0pwhyycljjscpz12fgfq41vh1rr36qa2xqqc0rkrn5k";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib procps libxml2
  ];
  installPhase = ''
    mkdir -p $out/bin
    mv dbus-map $out/bin
  '';
  meta = with lib; {
    description = "Simple utility for enumerating D-Bus endpoints, an nmap for D-Bus";
    homepage = https://github.com/taviso/dbusmap;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
