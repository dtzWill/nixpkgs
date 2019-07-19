{ stdenv, fetchFromGitHub, pkgconfig, libpng, zlib, lcms2 }:

stdenv.mkDerivation rec {
  pname = "pngquant";
  version = "2.12.3";

  src = fetchFromGitHub {
    owner = "pornel";
    repo = pname;
    rev = version;
    sha256 = "0qiznyc0bvryz8yqszp232illqycsibnhlchjhkiy3q3dbj3dwi3";
    fetchSubmodules = true;
  };

  preConfigure = "patchShebangs .";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libpng zlib lcms2 ];

  meta = with stdenv.lib; {
    homepage = https://pngquant.org/;
    description = "A tool to convert 24/32-bit RGBA PNGs to 8-bit palette with alpha channel preserved";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.volth ];
  };
}
