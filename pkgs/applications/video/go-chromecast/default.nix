{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  #version = "0.0.12";
  version = "2019-10-20";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    #rev = "refs/tags/v${version}";
    rev = "5912b85e5506b9f55e88c1ddece05ce79c3171c0";
    sha256 = "1nydi3kw35gdwx60h8qnl491xavw87vgj4ffw8124gbakrq470w7";
  };
  modSha256 = "01zmhrkgdfkf0ssd7mydf6lhqipwcqbm9bim5sayhms4bzbljaic";

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
