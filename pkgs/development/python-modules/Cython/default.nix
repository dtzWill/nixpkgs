{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub # fetchPypi
, python
, glibcLocales
, pkgconfig
, gdb
, numpy
, ncurses
}:

let
  excludedTests = []
    # cython's testsuite is not working very well with libc++
    # We are however optimistic about things outside of testsuite still working
    ++ stdenv.lib.optionals (stdenv.cc.isClang or false) [ "cpdef_extern_func" "libcpp_algo" ]
    # Some tests in the test suite isn't working on aarch64. Disable them for
    # now until upstream finds a workaround.
    # Upstream issue here: https://github.com/cython/cython/issues/2308
    ++ stdenv.lib.optionals stdenv.isAarch64 [ "numpy_memoryview" ]
    ++ stdenv.lib.optionals stdenv.isi686 [ "future_division" "overflow_check_longlong" ]
  ;

in buildPythonPackage rec {
  pname = "Cython";
  version = "0.29rc1";

  src = fetchFromGitHub {
    owner = "cython";
    repo = "cython";
    rev = "9f2869067b2cf8e86aa0c52fad90a477fe7fae87";
    sha256 = "1w7bnwmj3dvp9s567jfzyf63i0lkihmjfby004sx3h7cccz164pl";
  };
  #src = fetchPypi {
  #  inherit pname version;
  #  sha256 = "1q3rk46hcn7lnpyv4vc2dqamxfmhkwrkfhadb80frxk43wj7aidn";
  #};

  nativeBuildInputs = [
    pkgconfig
  ];
  checkInputs = [
    numpy ncurses
  ];
  buildInputs = [ glibcLocales gdb ];
  LC_ALL = "en_US.UTF-8";

  checkPhase = ''
    export HOME="$NIX_BUILD_TOP"
    ${python.interpreter} runtests.py -j$NIX_BUILD_CORES \
      ${stdenv.lib.optionalString (builtins.length excludedTests != 0)
        ''--exclude="(${builtins.concatStringsSep "|" excludedTests})"''}
  '';

  doCheck = !stdenv.isDarwin;

  meta = {
    description = "An optimising static compiler for both the Python programming language and the extended Cython programming language";
    homepage = http://cython.org;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
