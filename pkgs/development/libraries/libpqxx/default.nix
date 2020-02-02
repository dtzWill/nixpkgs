{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python3, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "0j3qarlmy90vp3y52w9jlr3a6lqssxqg2bcdp91bz4y7z2pprd2n";
  };

  nativeBuildInputs = [ gnused python3 ];
  buildInputs = [ postgresql doxygen xmlto ];

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--enable-shared" ];

  meta = {
    description = "A C++ library to access PostgreSQL databases";
    homepage = http://pqxx.org/development/libpqxx/;
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.eelco ];
  };
}
