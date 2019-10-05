{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "unstable-2019-10-05";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    #rev = "v${version}";
    rev = "69db448dd3a806950032bf4b631f2ec2a2c7a13c";
    sha256 = "12xhnpcbxkc3ic692svhfvndkjykpb7kmar30sis25r5fa76yk6v";
  };

  modSha256 = "1jsyxqkmw4ap4c1fh1vj4j31wnbfyrhh2qgp3rnlryp004v6x9qs";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
