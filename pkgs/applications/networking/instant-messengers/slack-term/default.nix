{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "0.4.1-git";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    #rev = "v${version}";
    rev = "d36cd2d125bc2e5037110cfd0a8ca0e3efa72642";
    sha256 = "19k2rkfqqjz3jhi1bbrah9rwfqhnw13rf5xdy8rbgjv992d84vpv";
  };

  modSha256 = "0lw5j1nxbsc1clvwscyvpy8vkww4yk3qiffpnqqrn4sqz0m8cb83";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
