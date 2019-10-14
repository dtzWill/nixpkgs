{ stdenv, fetchFromGitHub, rustPlatform, nix, boost, graphviz, darwin }:
rustPlatform.buildRustPackage rec {
  pname = "nix-du";
  version = "unstable-2019-09-30";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    rev = "2601d1fcdc9752c025a87687e3e5b01ba78e3a72";
    sha256 = "1m4cn18f10gwjywxnc3i9rq5w08ghbdi958wqd2w6242kyyj8qk3";
  };
  cargoSha256 = "071gbhxbvnwi7n3zpy7bmlprzir0sl0f0pb191xg2ynw678prd7v";

  doCheck = true;
  checkInputs = [ graphviz ];

  buildInputs = [
    boost
    nix
  ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with stdenv.lib; {
    description = "A tool to determine which gc-roots take space in your nix store";
    homepage = https://github.com/symphorien/nix-du;
    license = licenses.lgpl3;
    maintainers = [ maintainers.symphorien ];
    platforms = platforms.unix;
  };
}
