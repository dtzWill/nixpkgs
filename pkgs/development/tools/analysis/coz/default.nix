{ stdenv
, fetchFromGitHub
, libelfin
, ncurses
, nodejs
, python3
, python3Packages
}:
stdenv.mkDerivation rec {
  pname = "coz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "plasma-umass";
    repo = "coz";
    rev = version;
    sha256 = "0a55q3s8ih1r9x6fp7wkg3n5h1yd9pcwg74k33d1r94y3j3m0znr";
  };

  buildInputs = [
    nodejs
    libelfin
    ncurses
    python3
    python3Packages.docutils
  ];

  installPhase = ''
    mkdir -p $out/share/man/man1
    make install prefix=$out
  '';

  meta = {
    homepage = "https://github.com/plasma-umass/coz";
    description = "Coz: Causal Profiling";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ zimbatm ];
  };
}
