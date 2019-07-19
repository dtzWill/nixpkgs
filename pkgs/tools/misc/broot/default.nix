{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i6ayp295xnppq92lc1fsfyrjkxrkvsva07yby45qa0l92nihqpy";
  };

  cargoSha256 = "0fsdkdckn4f8hz0xp33r2sx81n7h4qjbjg5dbxnzwk6xv75fbkfx";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
