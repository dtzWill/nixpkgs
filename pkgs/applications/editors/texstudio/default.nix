{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig, hunspell }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-28";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "ce6595446701aa6e9967a53d8281fa09ddfd56b1";
    sha256 = "1mncf6hpylmqiyk7lmrxx02n4mkjyqzib4xzvb12n1s0y8dllix1";
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
