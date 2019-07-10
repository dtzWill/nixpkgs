{ stdenv, fetchFromGitHub, cmake, flex, bison }:

stdenv.mkDerivation rec {
  pname = "minizinc";
  version = "2.3.0";

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ cmake flex bison ];

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "libminizinc";
    # tags on the repo are disappearing: See https://github.com/MiniZinc/libminizinc/issues/257
    # optimistically, let's see if it happens again:
    rev = "refs/tags/${version}";
    sha256 = "0k48j22qapxzljmyv6hpga272hcw5l2l55md9ixivysg3v3x8ssi";
  };

  meta = with stdenv.lib; {
    homepage = https://www.minizinc.org/;
    description = "MiniZinc is a medium-level constraint modelling language.";

    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';

    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheenobu ];
  };
}
