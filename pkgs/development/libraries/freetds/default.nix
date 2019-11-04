{ stdenv, fetchurl, autoreconfHook, pkgconfig
, openssl
, odbcSupport ? true, unixODBC ? null }:

assert odbcSupport -> unixODBC != null;

# Work is in progress to move to cmake so revisit that later

stdenv.mkDerivation rec {
  name = "freetds-${version}";
  version = "1.1.20";

  src = fetchurl {
    url    = "https://www.freetds.org/files/stable/${name}.tar.bz2";
    sha256 = "06n4m9fh6i8ls59bkwq23129p2jgr6lac6z3z1j25i08aaa9nm7w";
  };

  buildInputs = [
    openssl
  ] ++ stdenv.lib.optional odbcSupport unixODBC;

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Libraries to natively talk to Microsoft SQL Server and Sybase databases";
    homepage    = http://www.freetds.org;
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
