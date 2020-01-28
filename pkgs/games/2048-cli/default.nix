{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "2048-cli";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "tiehuis";
    repo = pname;
    rev = "v${version}";
    sha256 = "09nv10np0jiaw4qj0ar3ny2m9ba8jwa3x7kqlfq0zb28559apcx4";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "CC=cc" ];

  buildTargets = "curses";

  installPhase = ''
    runHook preInstall
    install -Dm755 2048 $out/bin/2048-cli
    runHook postInstall
  '';
}
