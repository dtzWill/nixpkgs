{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lf";
  version = "15";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = pname;
    rev = "r${version}";
    sha256 = "1fjwkng6fnbl6dlicbxj0z92hl9xggni5zfi3nsxn3fa6rmzbiay";
  };

  modSha256 = "0xc5cyr0873cybd38gyyfpgwn2x6slbkc5w1h5i71fpc757rxj7c";

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
