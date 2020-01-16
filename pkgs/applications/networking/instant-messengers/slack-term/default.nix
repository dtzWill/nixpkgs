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

  modSha256 = "1spzwqbiiy76yps482r4dyb5radliiwacz5zjgv24d0yfs6hqw4x";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
