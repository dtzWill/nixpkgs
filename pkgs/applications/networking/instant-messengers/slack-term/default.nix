{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "unstable-2019-10-12";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    #rev = "v${version}";
    rev = "aa5d501a0db4cbddb1072dc8030813f91a1bd2eb";
    sha256 = "1g3fdhxidcjcd3wxwmly4dzdjfa46cmrsv5c39v5f3nlzvz9ssk5";
  };

  modSha256 = "1jsyxqkmw4ap4c1fh1vj4j31wnbfyrhh2qgp3rnlryp004v6x9qs";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
