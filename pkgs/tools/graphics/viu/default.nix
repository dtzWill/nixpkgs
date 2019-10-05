{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "viu";
  version = "0.2.2-git";

  src = fetchFromGitHub {
    owner = "atanunq";
    repo = "viu";
    #rev = "v${version}";
    rev = "f99a4b428b24a90faf7f2d501745bc1857ba34bd";
    sha256 = "12ihhd88lh98xkf9s4i4lc19wvpgwa07pyj76b282sjms4n4qcjh";
  };

  cargoSha256 = "0pdirzb14qy702rxpz0203hp5ribkp5bq4fg25hjzck3awz9i95n";

  meta = with lib; {
    description = "A command-line application to view images from the terminal written in Rust";
    homepage = "https://github.com/atanunq/viu";
    license = licenses.mit;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
  };
}
