{ stdenv, lib, fetchFromGitHub,
  pkgconfig, autoreconfHook,
  flex, yacc, zlib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "igraph";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "igraph";
    repo = pname;
    rev = version;
    sha256 = "0sxxq939ir6ws18mgrq8kc74wzc5spdaq79y67q2h2rx3h8jzf27";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ flex yacc zlib libxml2 ];

  # This file is normally generated by igraph's bootstrap.sh, but we can do it
  # ourselves. ~ C.
  postPatch = ''
    echo "${version}" > IGRAPH_VERSION
  '';

  meta = {
    description = "The network analysis package";
    homepage = https://igraph.org/;
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
