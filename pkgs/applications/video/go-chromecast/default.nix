{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0s3ylx6sq8fy9pfzpcs00qqv6hw8mfrsvpg7hnc82fk36gn07ih0";
  };
  modSha256 = "09cxgjz3hm900rgckhnlm6riqywgvr9j7c0pnxl888d8sffhjk6f";

  patches = [ ./mkv.patch ];

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
