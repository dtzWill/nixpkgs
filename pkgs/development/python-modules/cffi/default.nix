{ stdenv, buildPythonPackage, isPy27, isPyPy, fetchPypi, libffi, pycparser, pytest }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.11.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07fiy4wqg8g08x38r04ydjr8n6g0g74gb8si8b6jhymijalq746z";
  };

  patches = stdenv.lib.optional (isPy27 && stdenv.cc.isClang) ./clang.patch;

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ libffi pycparser ];
  buildInputs = [ pytest ];

  # On Darwin, the cffi tests want to hit libm a lot, and look for it in a global
  # impure search path. It's obnoxious how much repetition there is, and how difficult
  # it is to get it to search somewhere else (since we do actually have a libm symlink in libSystem)
  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace testing/cffi0/test_parsing.py \
      --replace 'lib_m = "m"' 'lib_m = "System"' \
      --replace '"libm" in name' '"libSystem" in name'
    substituteInPlace testing/cffi0/test_unicode_literals.py --replace 'lib_m = "m"' 'lib_m = "System"'
    substituteInPlace testing/cffi0/test_zdistutils.py --replace 'self.lib_m = "m"' 'self.lib_m = "System"'
    substituteInPlace testing/cffi1/test_recompiler.py --replace 'lib_m = "m"' 'lib_m = "System"'
    substituteInPlace testing/cffi0/test_function.py --replace "lib_m = 'm'" "lib_m = 'System'"
    substituteInPlace testing/cffi0/test_verify.py --replace "lib_m = ['m']" "lib_m = ['System']"
  '';

  # The tests use -Werror but with python3.6 clang detects some unreachable code.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionals stdenv.cc.isClang [ "-Wno-unused-command-line-argument" "-Wno-unreachable-code" ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ domenkozar ];
    homepage = https://cffi.readthedocs.org/;
    license = with licenses; [ mit ];
    description = "Foreign Function Interface for Python calling C code";
  };
}
