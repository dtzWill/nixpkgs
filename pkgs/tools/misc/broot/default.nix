{ stdenv, rustPlatform, fetchFromGitHub, coreutils, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pbjlfwv4s50s731ryrcc54200g2i04acdxrxk4kpcvi6b19kbky";
  };

  cargoSha256 = "1fzjr4hkpakvn69znylkfnl3ghgnnn0jpybbr9x013hz0xm07qi9";
  verifyCargoDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  # Fix invocations expecting /bin/* to exist
  # not very pretty when expanded but at least they work :)
  postPatch = ''
    substituteInPlace src/verb_store.rs \
      --replace /bin/cp ${coreutils}/bin/cp \
      --replace /bin/mkdir ${coreutils}/bin/mkdir \
      --replace /bin/mv ${coreutils}/bin/mv \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  postInstall = ''
    # install shell completion files
    OUT_DIR=target/release/build/broot-*/out

    installShellCompletion --bash $OUT_DIR/{br,broot}.bash
    installShellCompletion --fish $OUT_DIR/{br,broot}.fish
    installShellCompletion --zsh $OUT_DIR/{_br,_broot}
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
