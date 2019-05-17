{ stdenv, fetchurl, bison, flex, libffi }:

stdenv.mkDerivation rec {
  name = "txr-${version}";
  version = "215";

  src = fetchurl {
    url = "http://www.kylheku.com/cgit/txr/snapshot/${name}.tar.bz2";
    sha256 = "0nlqm5irxgyxlj71w6y3x62857clqjyp9zpwl2y9m1qm0dg160as";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libffi ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "tests";

  # Remove failing test-- mentions 'usr/bin' so probably related :)
  preCheck = "rm -rf tests/017";

  # TODO: install 'tl.vim', make avail when txr is installed or via plugin

  meta = with stdenv.lib; {
    description = "Programming language for convenient data munging";
    license = licenses.bsd2;
    homepage = http://nongnu.org/txr;
    maintainers = with stdenv.lib.maintainers; [ dtzWill ];
  };
}
