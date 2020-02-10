{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-09";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "2b95588d8f1db8376461f8a06d7fae6340dae110";
    sha256 = "1w49fwx7cbnn5hd25kmd8cnv2hwi9wmpnz3vl6p92sw5027wcyvb";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtscript qtsvg poppler zlib ];

  qmakeFlags = [ "NO_APPDATA=True" ];

  meta = with lib; {
    description = "TeX and LaTeX editor";
    longDescription=''
      Fork of TeXMaker, this editor is a full fledged IDE for
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = http://texstudio.sourceforge.net;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cfouche ];
  };
}
