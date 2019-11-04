{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  #version = "0.0.13";
  version = "2019-10-23";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    #rev = "refs/tags/v${version}";
    rev = "c44efa2cc92aaf579bdfddb8aa5a46ac524a5136";
    sha256 = "0gqifw7d47bxj922fs9b7gy8rqqbw0dljdjg30n4q427jh9g6ska";
  };
  modSha256 = "03b1f5vfrzwd69sqcr231i6bgl34jjjjryqmfflh7b57fpym8215";

  patches = [ ./mkv.patch ];

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
