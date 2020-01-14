{ stdenv, fetchurl, cmake, pkgconfig, darwin
, openexr, zlib, imagemagick, libGLU, libGL, freeglut, fftwFloat
, fftw, gsl, libexif, perl, opencv, qt5, netpbm
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pfstools";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${name}.tgz";
    sha256 = "04rlb705gmdiphcybf9dyr0d5lla2cfs3c308zz37x0vwi445six";
  };

  outputs = [ "out" "dev" "man"];

  cmakeFlags = ''
    -DWITH_MATLAB=false 
  '';

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    openexr zlib imagemagick fftwFloat
    fftw gsl libexif perl opencv qt5.qtbase netpbm
  ] ++ (if stdenv.isDarwin then (with darwin.apple_sdk.frameworks; [
    OpenGL GLUT
  ]) else [
    libGLU libGL freeglut
  ]);

  patches = [ ./threads.patch ./pfstools.patch ];

  meta = with stdenv.lib; {
    homepage = http://pfstools.sourceforge.net/;
    description = "Toolkit for manipulation of HDR images";
    platforms = platforms.linux;
    license = licenses.lgpl2;
    maintainers = [ maintainers.juliendehos ];
  };
}
