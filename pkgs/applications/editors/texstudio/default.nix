{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-04";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "77894aeaa10bc001b43a3119eb1bd60250506e12";
    sha256 = "0k27disr4npc64qjf5zl6ghpsxc80v6bp63q06pbn0bd51h21y8h";
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
