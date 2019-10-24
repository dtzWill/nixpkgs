{ stdenv, fetchFromGitHub
, bison, flex
, libedit, libevent, libressl, ncurses, zlib
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
  buildInputs = [ libedit libevent libressl ncurses zlib ];

  postPatch = ''
    for x in bc ftp telnet ul; do
      substituteInPlace usr.bin/$x/Makefile \
        --replace lcurses lncurses
    done

    substituteInPlace usr.bin/pkg-config/Makefile \
      --replace /usr/libdata $out

    find . -name Makefile -type f -print0 | xargs -0r \
      sed -i \
        -e 's,-o $[{(][A-Z]\+OWN[)}],,g' \
        -e 's,-g $[{(][A-Z]\+GRP[)}],,g' \
        \
        -e 's,/usr/,/,g'

    sed -i -e 's,SKIPDIR=.*,\0 spell,' usr.bin/Makefile
  '';

  enableParallelBuilding = true;
}
