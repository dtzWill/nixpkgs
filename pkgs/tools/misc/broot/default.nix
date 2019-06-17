{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hfgwy4vnag8asz9a55bdvw3ivy77rjay7xr8ilbrvc0l0v4qbiv";
  };

  cargoSha256 = "027g0z9y406pb8xp7vpsqk8xyl3m91bzpd5sraq6sn4w2l8aa5fz";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
