{ mkDerivation /* qt */, lib, fetchFromGitHub, qtbase, qtwebengine, qtwebkit, qmake, makeWrapper, minizinc }:

mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.3.1";

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine qtwebkit ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    sha256 = "0w9p5j2i7q4khmxyk2lr7a3qb2kd6ff1hfssxhgpm7zgzixm2300";
  };

  sourceRoot = "source/MiniZincIDE";

  enableParallelBuilding = true;

  qtWrapperArgs = [
    ''--prefix PATH ":" ${lib.makeBinPath [ minizinc ]}''
  ];

  meta = with lib; {
    homepage = https://www.minizinc.org/;
    description = "IDE for MiniZinc, a medium-level constraint modelling language";

    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';

    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.dtzWill ];
  };
}
