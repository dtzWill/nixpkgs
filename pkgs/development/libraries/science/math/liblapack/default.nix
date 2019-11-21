{
  stdenv,
  fetchurl,
  gfortran,
  cmake,
  python2,
  shared ? false
}:
let
  inherit (stdenv.lib) optional;
  version = "3.9.0";
in

stdenv.mkDerivation rec {
  name = "liblapack-${version}";
  src = fetchurl {
    url = "https://github.com/Reference-LAPACK/lapack/archive/v${version}.tar.gz";
    sha256 = "0wym3az9vs50clvp696d0ydcpni3pq69smkzpbgsyijzpgqqfq0h";
  };

  buildInputs = [ gfortran cmake ];
  nativeBuildInputs = [ python2 ];

  cmakeFlags = [
    "-DUSE_OPTIMIZED_BLAS=ON"
    "-DCMAKE_Fortran_FLAGS=-fPIC"
  ]
  ++ (optional shared "-DBUILD_SHARED_LIBS=ON");

  doCheck = ! shared;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
    description = "Linear Algebra PACKage";
    homepage = http://www.netlib.org/lapack/;
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
