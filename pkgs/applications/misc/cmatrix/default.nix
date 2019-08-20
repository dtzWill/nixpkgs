{ stdenv, fetchFromGitHub, cmake, pkgconfig, ncurses }:

stdenv.mkDerivation rec {
  pname = "cmatrix";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "abishekvashok";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h9jz4m4s5l8c3figaq46ja0km1gimrkfxm4dg7mf4s84icmasbm";
  };

  # Fonts are only installed if the directories exist, so create them:
  preConfigure = "mkdir -p $out/share/consolefonts $out/share/fonts/X11/misc";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Simulates the falling characters theme from The Matrix movie";
    longDescription = ''
      CMatrix simulates the display from "The Matrix" and is based
      on the screensaver from the movie's website.
    '';
    homepage = https://github.com/abishekvashok/cmatrix;
    platforms = ncurses.meta.platforms;
    maintainers = [ maintainers.AndersonTorres ];
  };
}
