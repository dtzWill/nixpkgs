{ stdenv, fetchFromGitHub, zlib
, ocaml, dune, ocamlfuse, findlib, gapi_ocaml, ocaml_sqlite3, camlidl }:

stdenv.mkDerivation rec {
  name = "google-drive-ocamlfuse-${version}";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "astrada";
    repo = "google-drive-ocamlfuse";
    rev = "v${version}";
    sha256 = "0h5d1m9jgd737158ggp4mz46956bwhv30r2pyqljvfwqn6m6mwz9";
  };

  nativeBuildInputs = [ dune ];

  buildInputs = [ zlib ocaml ocamlfuse findlib gapi_ocaml ocaml_sqlite3 camlidl ];

  buildPhase = "jbuilder build @install";
  installPhase = "mkdir $out && dune install --prefix $out";

  meta = {
    homepage = http://gdfuse.forge.ocamlcore.org/;
    description = "A FUSE-based file system backed by Google Drive, written in OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ obadz ];
  };
}
