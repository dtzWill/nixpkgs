{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig, hunspell }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-25";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "6d0d0a0bb079fe5b867eaba9646c26b9d6b98554";
    sha256 = "0ydsc4872jz78rvk7sr5fympqr6rjahnqzvmv16w7kw4wnmz8k37";
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
