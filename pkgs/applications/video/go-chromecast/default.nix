{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  #version = "0.0.11";
  version = "2019-10-01";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    #rev = "refs/tags/v${version}";
    rev = "984c9839525b07d00ca62f1459d95d6ad5232c94";
    sha256 = "15vz51rwf2h95n11ibfw5b9rp3ajzvbm68wina4mmx5d91ba58fl";
  };
  modSha256 = "01zmhrkgdfkf1ssd7mydf6lhqipwcqbm9bim5sayhms4bzbljaic";

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
