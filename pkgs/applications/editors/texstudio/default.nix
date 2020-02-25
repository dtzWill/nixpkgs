{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "unstable-2020-02-23";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = "5d11be544dc8f2aa5b42afe1f9d7a3cfac199d63";
    sha256 = "13r0vkn1i8hig37hvjdc98bf09vmph66bkyv6mqdg4b8iihjr8h5";
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
