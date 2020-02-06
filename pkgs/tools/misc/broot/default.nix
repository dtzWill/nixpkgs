{ stdenv, rustPlatform, fetchFromGitHub, coreutils, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lm90n2hi4ljyhb2qv13979xr0p5faxhq4rcfz0bmyygsfss0zl2";
  };

  cargoSha256 = "1rnk6lw6gxm1s0q9ciahzcymw4f10mpsj77n74scslald4fivj43";
  verifyCargoDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # install shell completion files
    OUT_DIR=target/release/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}
  '';

  postPatch = ''
    substituteInPlace src/verb_store.rs --replace '"/bin/' '"${coreutils}/bin/'
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
