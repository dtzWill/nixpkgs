{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "18aj8pkchlj3bqrzpjnrfp97iifvs56zdfmi26lzni788mi9bzmc";
  };

  cargoSha256 = "0avcwcbacsppv2an1sk50bpdhwkxr1b5ypq26rgzwnn53fcs8bm3";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
