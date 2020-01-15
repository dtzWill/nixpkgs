{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "unstable-2020-01-08";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    #rev = "v${version}";
    rev = "78d1eb5e13984b3d6b859d3f69553e2ad20643ab";
    sha256 = "19p0ijyqmmrilzmr3b4sm3ssdq2762cn34v62zjsvshhssw186lf";
  };

  modSha256 = "1jsyxqkmw4ap4c1fh1vj4j31wnbfyrhh2qgp3rnlryp004v6x9qs";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
