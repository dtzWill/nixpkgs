{ stdenv, fetchFromGitHub, rustPlatform, openssl, pkgconfig, libiconv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "starship";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "starship";
    repo = "starship";
    rev = "v${version}";
    sha256 = "0vlpvacay25dzb5wix9jd91j0j1nrwz4k8zglj7210mhabfpnxvb";
  };

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "1hijshwa0wn635zhx2g3l14s73pfjz76qfpvgwl24r15b10vb0nm";
  checkPhase = "cargo test -- --skip directory::home_directory --skip directory::directory_in_root";

  meta = with stdenv.lib; {
    description = "A minimal, blazing fast, and extremely customizable prompt for any shell";
    homepage = "https://starship.rs";
    license = licenses.isc;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.all;
  };
}
