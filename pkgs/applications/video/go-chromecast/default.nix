{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "13zb1vppn2i1p5in61rn546ad2246v1y4w664fkjs9jvd4yl5bw6";
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
