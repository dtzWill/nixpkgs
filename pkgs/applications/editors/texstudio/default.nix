{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtscript, qtsvg,
  poppler, zlib, pkgconfig }:

mkDerivation rec {
  pname = "texstudio";
  version = "3.0.0alpha1";

  src = fetchFromGitHub {
    owner = "${pname}-org";
    repo = pname;
    rev = version;
    sha256 = "19zn0ingpky0pd29093z3y84dbn890r04rz8panf81s22fkif9n1";
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
