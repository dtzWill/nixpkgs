{ stdenv, fetchFromGitHub, qmake, qtbase, qtwebengine, hicolor-icon-theme, makeDesktopItem }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in stdenv.mkDerivation rec {
  version = "2.7.1";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "1cj8jp8l5g097dg8gyav3wd2jirinllyn7mga954g2zf3anvy0vv";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine hicolor-icon-theme ];

  meta = with stdenv.lib; {
    inherit description;
    homepage = "https://tamlok.github.io/vnote";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
