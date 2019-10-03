{ stdenv, fetchFromGitHub
, bison, flex
, libedit, libevent, libressl, zlib
, libcurses
}:

stdenv.mkDerivation rec {
  pname = "lobase";
  version = "unstable-2018-04-06";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = pname;
    rev = "c52cc6690301b36ccdc155ffc2c4a8ff29cd92c0";
    sha256 = "1mjqf5f06bn3aapwxwm1dzlil8sa455jarj15qbcdcir6xhl0dzy";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libedit libevent libressl libcurses zlib ];

  enableParallelBuilding = true;
}
