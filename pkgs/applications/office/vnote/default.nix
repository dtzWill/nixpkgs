{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtwebengine }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in mkDerivation rec {
  version = "unstable-2019-11-19";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    #rev = "v${version}";
    rev = "eeb1d59e367a73d3aef800fd04e8dd1c30966060";
    sha256 = "1b4z7gq26bi3zcbc5c056zxrlh9xcz4101s99sv3l6yzm7p4qhj3";
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
