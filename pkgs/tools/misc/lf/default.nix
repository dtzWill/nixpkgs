{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lf";
  version = "17";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = pname;
    rev = "r${version}";
    sha256 = "0hs70hbbwz9kbbf13l2v32yv70n4aw8sz7rky82qdcqcpnpisjq8";
  };

  modSha256 = "109w7fzqc5ap5j5np7c2c5h7py3cqdm7zavp424xs9k16pd0qrln";

  buildFlagsArray = [ "-ldflags=-s -w -X main.gVersion=r${version}" ];

  postInstall = ''
    install -D --mode=444 lf.1 $out/share/man/man1/lf.1
  '';

  meta = with lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = https://godoc.org/github.com/gokcehan/lf;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
