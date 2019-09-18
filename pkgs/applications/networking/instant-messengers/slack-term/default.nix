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
    rev = "f1d94f069af129a0c800fac0f9c71e4565176370";
    sha256 = "1wskjivg3brryn6hl20nxq3n9b4dxa6cbw7vifa34p4kjkrgd07x";
  };

  modSha256 = "0lw5j1nxbsc1clvwscyvpy8vkww4yk3qiffpnqqrn4sqz0m8cb83";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
