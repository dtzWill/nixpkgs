{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  # https://github.com/erroneousboat/slack-term
  name = "slack-term-${version}";
  version = "0.4.1-git";

  goPackagePath = "github.com/erroneousboat/slack-term";

  src = fetchFromGitHub {
    owner = "erroneousboat";
    repo = "slack-term";
    #rev = "v${version}";
    rev = "6e75095daa07629ba17164037f51cc5fb6509f45";
    sha256 = "183hnbj7dj6dbi5n4wzpgy2sa325sznaspz5jn4zbsslkkwhiixj";
  };

  meta = with stdenv.lib; {
    description = "Slack client for your terminal";
    homepage = https://github.com/erroneousboat/slack-term;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
