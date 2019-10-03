{ stdenv, fetchurl, cmake, pkgconfig, polkit, glib, qtbase }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "polkit-qt-1";
  version = "0.113.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "19v3ap742l1gn28llbnzm0l5a6rjs25gxqjnc6vgy47gahlnm1jv";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  propagatedBuildInputs = [ polkit glib qtbase ];

  postFixup = ''
    # Fix library location in CMake module
    sed -i "$dev/lib/cmake/PolkitQt5-1/PolkitQt5-1Config.cmake" \
        -e "s,\\(set_and_check.POLKITQT-1_LIB_DIR\\).*$,\\1 \"''${!outputLib}/lib\"),"
  '';

  meta = {
    description = "A Qt wrapper around PolKit";
    maintainers = with stdenv.lib.maintainers; [ ttuegel ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
