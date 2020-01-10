{ stdenv, rustPlatform, fetchFromGitHub, coreutils }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b64cl5080rzfbxx54y60klcdv0hvrmwklskl95pkcspgfffk2nm";
  };

  cargoSha256 = "0w62sxdl2w1wc0fjxszpifw9jxl35nz5nsmfr6pd0lvbgm3c7vba";

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
