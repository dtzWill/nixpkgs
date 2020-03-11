{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, ncurses }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.2";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "1sax3kl5js1ynlgx15g4rndja1x7z1b7nnmhj7mpjc4ksvvl2kx1";
    fetchSubmodules = true;
  };

  modSha256 = "1jkn1j7m9mm2bvnxnrkxbcksmzbn897bwd59nric3mnc87ysb6ns";

  subPackages = [ "cmd/micro" ];

  buildFlagsArray = [ "-ldflags=" "-X main.Version=${version}" ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/micro --prefix PATH : ${ncurses.dev}/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://micro-editor.github.io;
    description = "Modern and intuitive terminal-based text editor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}

