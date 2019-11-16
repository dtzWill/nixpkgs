{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtwebengine }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in mkDerivation rec {
  version = "2.7.2-git";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    #rev = "v${version}";
    rev = "55c1174ae17e9d07efd21555a746bc303cdd7e71";
    sha256 = "0k32014x3dqjvyxlghb9jz1n6izpmw6gz99yhrhkbz66xd7qac4c";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine ];

  meta = with lib; {
    inherit description;
    homepage = "https://tamlok.github.io/vnote";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
