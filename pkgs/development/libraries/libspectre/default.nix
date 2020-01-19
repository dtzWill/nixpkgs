{ fetchurl, stdenv, pkgconfig, ghostscript, cairo }:

stdenv.mkDerivation rec {
  pname = "libspectre";
  version = "0.2.8";

  src = fetchurl {
    url = "https://libspectre.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "1a67iglsc3r05mzngyg9kb1gy8whq4fgsnyjwi7bqfw2i7rnl9b5";
  };

  patches = [ ./libspectre-0.2.7-gs918.patch ];

  buildInputs = [
    # Need `libgs.so'.
    pkgconfig ghostscript cairo /*for tests*/
  ];

  doCheck = true;

  meta = {
    homepage = http://libspectre.freedesktop.org/;
    description = "PostScript rendering library";

    longDescription = ''
      libspectre is a small library for rendering Postscript
      documents.  It provides a convenient easy to use API for
      handling and rendering Postscript documents.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
