{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libuv, sqlite-replication }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0670c1c84lcf5vl3h6mlff00fz2fnm766bzlk526sjjzysx3zjya";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libuv sqlite-replication ];

  meta = {
    description = "Expose a SQLite database over the network and replicate it across a cluster of peers";
    homepage = https://github.com/CanonicalLtd/dqlite/;
    license = licenses.asl20;
    maintainers = with maintainers; [ joko ];
    platforms = platforms.unix;
  };
}
