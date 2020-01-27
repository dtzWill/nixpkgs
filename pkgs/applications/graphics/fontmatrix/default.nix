{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  pname = "fontmatrix";
  version = "unstable-2019-04-16";

  src = fetchFromGitHub {
    owner = "fontmatrix";
    repo = "fontmatrix";
#    rev = "v${version}";
    rev = "6279b38ef0b1de01b605fa7ca2b0c463369427c1";
    sha256 = "0i63chpscr2z3102rbgnf9a62xzqlvwx6708dzijym8929lw51ii";
  };

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Fontmatrix is a free/libre font explorer for Linux, Windows and Mac";
    homepage = https://github.com/fontmatrix/fontmatrix;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
