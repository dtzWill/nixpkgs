{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-12";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "57725824b2a8321e33923b4e6dc55ea79c3765ce";
    sha256 = "1mdg5wakvg1bglmp9d67qzns7aa6n0074yaharz89mp79sh5d03h";
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
