{ stdenv, fetchFromGitHub, boxfort, cmake, libcsptr, pkgconfig, gettext, dyncall
, nanomsg, python37Packages }:

stdenv.mkDerivation rec {
  version = "2.3.3";
  pname = "criterion";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "Criterion";
    rev = "v${version}";
    sha256 = "0y1ay8is54k3y82vagdy0jsa3nfkczpvnqfcjm5n9iarayaxaq8p";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boxfort
    dyncall
    gettext
    libcsptr
    nanomsg
  ];

  checkInputs = with python37Packages; [
    cram
  ];
  cmakeFlags = [ "-DCTESTS=ON" ];
  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH
    '';
  checkTarget = "criterion_tests test";

  meta = with stdenv.lib; {
    description = "A cross-platform C and C++ unit testing framework for the 21th century";
    homepage = "https://github.com/Snaipe/Criterion";
    license = licenses.mit;
    maintainers = with maintainers; [ Yumasi ];
    platforms = platforms.unix;
  };
}
