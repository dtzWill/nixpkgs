{ stdenv, fetchFromGitHub, cmake, enableShared ? true }:

stdenv.mkDerivation rec {
  version = "6.1.0";
  pname = "fmt";

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = pname;
    rev = version;
    sha256 = "08v28k1iypjand8ys75lxz6ya2qm33yd6552024z79r2vcq27hh3";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFMT_TEST=TRUE"
    "-DBUILD_SHARED_LIBS=${if enableShared then "TRUE" else "FALSE"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  # preCheckHook ensures the test binaries can find libfmt.so.5
  preCheck = if enableShared
             then "export LD_LIBRARY_PATH=\"$PWD\""
             else "";

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = http://fmtlib.net/;
    downloadPage = https://github.com/fmtlib/fmt/;
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
