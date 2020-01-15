{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "08732gkl0g570idyysz883knfp71sj5xkva9xv4zq5y9z20wsl9m";
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
