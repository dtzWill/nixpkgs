{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "expat";
  version = "2.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "00ji8zv33r2izb405bvp09ixj8fkwmd5y78pwhsdm0jsn140j4ws";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
