{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  # https://github.com/erroneousboat/slack-term
  pname = "slack-term";
  version = "0.5.0";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    rev = "v${version}";
    sha256 = "1fbq7bdhy70hlkklppimgdjamnk0v059pg73xm9ax1f4616ki1m6";
  };

  modSha256 = "1spzwqbiiy76yps482r4dyb5radliiwacz5zjgv24d0yfs6hqw4x";

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
