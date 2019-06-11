{ stdenv, fetchurl, pkgconfig, gtk2 }:

stdenv.mkDerivation rec {
  pname = "scite";
  version = "4.1.6";

  src = fetchurl {
    url = "https://www.scintilla.org/scite${builtins.replaceStrings ["."][""] version}.tgz";
    sha256 = "0k10qjil101mxlmd39sdz1n9yaif0x5q6vl03is48jrh4lvvlfyy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 ];
  sourceRoot = "scintilla/gtk";


  makeFlags = [ "prefix=${placeholder "out"}" ];
  buildPhase = ''
    make
    cd ../../scite/gtk
  '';

  meta = with stdenv.lib; {
    homepage = https://www.scintilla.org/SciTE.html;
    description = "SCIntilla based Text Editor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
  };
}
