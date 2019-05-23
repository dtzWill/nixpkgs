{ stdenv, pkgconfig, glib, libxml2, expat,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  ApplicationServices,
  python27, libpng ? null,
  fetchFromGitHub,
  autoreconfHook,
  gtk-doc,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "vips";
  version = "8.8.0";

  src = fetchFromGitHub {
    owner = "libvips";
    repo = "libvips";
    rev = "v${version}";
    sha256 = "079inl6j4lpqsgxj7n4zkv92dcd2lv07x2ihi8bykj199ch8s67r";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook gtk-doc gobject-introspection ];
  buildInputs = [ glib libxml2 fftw orc lcms
    imagemagick openexr libtiff libjpeg
    libgsf libexif python27 libpng expat ]
    ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  autoreconfPhase = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
