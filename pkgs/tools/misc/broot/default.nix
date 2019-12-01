{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dr4an5ch3jb965bi52hz08ksiqniv25hwi1a1f5hqm1fwggxqvj";
  };

  cargoSha256 = "127z0wphkj823aiq9cgxhgbcxdggzywblzhf03jgqj14mjwq6w20";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
