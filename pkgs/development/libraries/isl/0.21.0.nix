{ stdenv, fetchurl, gmp }:

stdenv.mkDerivation rec {
  name = "isl-0.21";

  src = fetchurl {
    url = "http://isl.gforge.inria.fr/${name}.tar.xz";
    sha256 = "0q29lpb4r5zfbvd00k2r9g6nwkr1h542j7inah4m1f9x5a2mhw3p";
  };

  buildInputs = [ gmp ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://isl.gforge.inria.fr/;
    license = stdenv.lib.licenses.lgpl21;
    description = "A library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = stdenv.lib.platforms.all;
  };
}
