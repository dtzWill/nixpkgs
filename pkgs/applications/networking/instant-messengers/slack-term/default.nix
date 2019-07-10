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
    rev = "c8f10dcc559adcf779d99d361edc2f35e98abe5d";
    sha256 = "0ij6irh49xkb0fx883sg60rqq1pfmq8h0apapa5qdnb0bzw49ar3";
  };

  modSha256 = "0lw5j1nxbsc1clvwscyvpy8vkww4yk3qiffpnqqrn4sqz0m8cb83";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
