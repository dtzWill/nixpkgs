{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig, hunspell }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-27";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "6d338195e90e1dd682c5f031c6da0f60a229d838";
    sha256 = "1j4var4zbq1cckfrisnr673n0ls1q233b4v244hr5bjd166dmq0j";
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
