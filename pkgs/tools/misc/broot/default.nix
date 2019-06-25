{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sq7p9qx2d2h047l5q9kwl5g5qi43d2xzn3mm7jdidbrh2ay1s3g";
  };

  cargoSha256 = "0fsdkdckn3f8hz0xp33r2sx81n7h4qjbjg5dbxnzwk6xv75fbkfx";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
