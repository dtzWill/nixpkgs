{ stdenv, rustPlatform, fetchFromGitHub, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rj1ab8q7102fqcw89cjwzkqk6lxvqkq8sbwfgw9xgn6spnbdkdr";
  };

  cargoSha256 = "17nazm4cgw4dm0vjlxgc93v28p960gls1203r61xbx6l7aibxrn3";

  # Fix invocations expecting /bin/* to exist
  # not very pretty when expanded but at least they work :)
  postPatch = ''
    substituteInPlace src/verb_store.rs \
      --replace /bin/cp ${coreutils}/bin/cp \
      --replace /bin/mkdir ${coreutils}/bin/mkdir \
      --replace /bin/mv ${coreutils}/bin/mv \
      --replace /bin/rm ${coreutils}/bin/rm
  '';

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
