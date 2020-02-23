{ stdenv, fetchFromGitHub
, pkgconfig
, freetype, giflib, gtk2, lcms2, libjpeg, libpng, libtiff, openjpeg, gifsicle
}:

stdenv.mkDerivation rec {
  p_name  = "mtPaint";
  ver_maj = "3.49";
  ver_min = "20";
  name = "${p_name}-${ver_maj}.${ver_min}";

  src = fetchFromGitHub {
    owner = "wjaguar";
    repo = p_name;
    rev = "e55eb7d3d14bc17ea92f5e5f00ecc538dced0aeb";
    sha256 = "1kc8p8lyrqzfqc95h76y7jm346hkykgksl15pwrnfh6rq8355ylw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    freetype giflib gtk2 lcms2 libjpeg libpng libtiff openjpeg gifsicle
  ];

  meta = {
    description = "A simple GTK painting program";
    longDescription = ''
      mtPaint is a simple GTK painting program designed for
      creating icons and pixel based artwork.  It can edit indexed palette
      or 24 bit RGB images and offers basic painting and palette manipulation
      tools. It also has several other more powerful features such as channels,
      layers and animation.
      Due to its simplicity and lack of dependencies it runs well on
      GNU/Linux, Windows and older PC hardware.
    '';
    homepage = http://mtpaint.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.vklquevs ];
  };
}

