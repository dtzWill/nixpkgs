{ lib, mkDerivation, fetchurl, makeWrapper, pkgconfig, zlib, freetype, cairo, lua5, texlive, ghostscript
, libjpeg, libpng, qtbase
}:

mkDerivation rec {
  pname = "ipe";
  version = "7.2.13";

  src = fetchurl {
    url = "https://dl.bintray.com/otfried/generic/ipe/7.2/${pname}-${version}-src.tar.gz";
    sha256 = "1a6a88r7j5z01z6k1z72a8g3n6lxdjjxxkdrzrfdd6df2gbs6g5g";
  };

  sourceRoot = "${pname}-${version}/src";

  IPEPREFIX = placeholder "out";
  URWFONTDIR = "${texlive}/texmf-dist/fonts/type1/urw/";
  LUA_PACKAGE = "lua";

  buildInputs = [
    libjpeg libpng zlib qtbase freetype cairo lua5 texlive ghostscript
  ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  postFixup = ''
    for prog in $out/bin/*; do
      wrapProgram "$prog" --prefix PATH : "${texlive}/bin"
    done
  '';

  enableParallelBuilding = true;

  #TODO: make .desktop entry

  meta = with lib; {
    description = "An editor for drawing figures";
    homepage = http://ipe.otfried.org;
    license = licenses.gpl3Plus;
    longDescription = ''
      Ipe is an extensible drawing editor for creating figures in PDF and Postscript format.
      It supports making small figures for inclusion into LaTeX-documents
      as well as presentations in PDF.
    '';
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.linux;
  };
}
