{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtwebengine }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in mkDerivation rec {
  version = "2.7.2";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    #rev = "v${version}";
    rev = "c828ef00c437fd7722f7bc8b4e8191016a930f18";
    sha256 = "1rmzjmp9qz8g3ci1dsmsqdk1rlrsjwp34fgs61b4m6r4ha6dqdp4";
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
