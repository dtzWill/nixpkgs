{ stdenv, buildGoModule, fetchFromGitHub, makeWrapper, ncurses }:

buildGoModule rec {
  pname = "micro";
  version = "2.0.1";

  goPackagePath = "github.com/zyedidia/micro";

  src = fetchFromGitHub {
    owner = "zyedidia";
    repo = "micro";
    rev = "v${version}";
    sha256 = "1gbin1miib0v4clbi4naff8051jcl7k7m254rs12knb458rbqq62";
    fetchSubmodules = true;
  };

  modSha256 = "1s9pr192cs1iys8k1zqi846zj0iqsryz4na4cp1l7avdalzqiswy";

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

