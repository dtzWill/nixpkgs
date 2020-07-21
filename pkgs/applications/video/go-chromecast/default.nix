{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1gxgavv4fzi4bx8pk850rfhnirbfn471p5q00lhkc675ppaf1jr3";
  };
  modSha256 = "04d5v45jq4ixmr9p241aq7ghwh1cvqbh80f3hk0055w76rchw9v1";

  patches = [ ./mkv.patch ];

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
