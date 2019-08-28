{ stdenv, fetchurl, cmake, pkgconfig, zlib, pcre, expat, sqlite, openssl, unixODBC, mysql }:

stdenv.mkDerivation rec {
  name = "poco-${version}";

  version = "1.9.3";

  src = fetchurl {
    url = "https://pocoproject.org/releases/${name}/${name}-all.tar.gz";
    sha256 = "0s5afgjzgi2d255i4x8m9fjvrsi9m5sjilny3c6innm8n964cg2q";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib pcre expat sqlite openssl unixODBC mysql.connector-c ];

  MYSQL_DIR = mysql.connector-c;
  MYSQL_INCLUDE_DIR = "${MYSQL_DIR}/include/mysql";

  cmakeFlags = [
    "-DPOCO_UNBUNDLED=ON"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://pocoproject.org/;
    description = "Cross-platform C++ libraries with a network/internet focus";
    license = licenses.boost;
    maintainers = with maintainers; [ orivej ];
  };
}
