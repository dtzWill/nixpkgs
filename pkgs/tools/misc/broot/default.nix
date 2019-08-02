{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k4ya4wwgix25n9frbdmlgp96sj4d738nhaxd9h9ixxm8n2w8f8w";
  };

  cargoSha256 = "1rz3di6m6s38vm1c8wsxlma8bq4my723jy4pqdx8m4hbvm75rz4j";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
