{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig, hunspell }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-03-07";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "f8d003f899e19be0975977e5d163c33f3e35fcfa";
    sha256 = "1krm3700lr6mrzn4726zmg9nzssh0iznw1d0w6qf1g1f71rs3790";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtscript qtsvg poppler zlib hunspell ];

  qmakeFlags = [ "NO_APPDATA=True" "USE_SYSTEM_HUNSPELL=True" ];

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
