{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    rev = "v${version}";
    sha256 = "1ds6a5d248wddlkpdaadvbwc7si3l363znzhkxy1y2b1shg93car";
  };

  cargoSha256 = "0zq9lwxsnrv54kc2wkh97imbr0f6jn6mb5s2bsxiyayr9msljx7x";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
