{ lib, stdenv, fetchFromGitHub, postgresql, doxygen, xmlto, python3, gnused }:

stdenv.mkDerivation rec {
  pname = "libpqxx";
  version = "7.0.4";

  src = fetchFromGitHub {
    owner = "jtv";
    repo = pname;
    rev = version;
    sha256 = "0nqn0s6d0ala3g1cyvvv3vhfpwvpjc2ab60z25byq1xrxsvbxi0m";
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
