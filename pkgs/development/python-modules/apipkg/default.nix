{ stdenv, buildPythonPackage, fetchPypi
, pytest, setuptools_scm, isPy3k }:

buildPythonPackage rec {
  pname = "apipkg";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37228cda29411948b422fae072f57e31d3396d2ee1c9783775980ee9c9990af6";
  };

  # https://github.com/pytest-dev/apipkg/issues/14
  patches = [ (builtins.toFile "pytest4.patch" ''
    --- a/test_apipkg.py
    +++ b/test_apipkg.py
    @@ -13,7 +13,7 @@
     class TestRealModule:
     
         def setup_class(cls):
    -        cls.tmpdir = py.test.ensuretemp('test_apipkg')
    +        cls.tmpdir = py.path.local('test_apipkg')
             sys.path = [str(cls.tmpdir)] + sys.path
             pkgdir = cls.tmpdir.ensure('realtest', dir=1)
    
  '') ];

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytest ];

  # Fix pytest 4 support. See: https://github.com/pytest-dev/apipkg/issues/14
  postPatch = ''
    substituteInPlace "test_apipkg.py" \
      --replace "py.test.ensuretemp('test_apipkg')" "py.path.local('test_apipkg')"
  '';

  # Failing tests on Python 3
  # https://github.com/pytest-dev/apipkg/issues/17
  checkPhase = let
    disabledTests = stdenv.lib.optionals isPy3k [
      "test_error_loading_one_element"
      "test_aliasmodule_proxy_methods"
      "test_eagerload_on_bython"
    ];
    testExpression = stdenv.lib.optionalString (disabledTests != [])
    "-k 'not ${stdenv.lib.concatStringsSep " and not " disabledTests}'";
  in ''
    py.test ${testExpression}
  '';

  meta = with stdenv.lib; {
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = licenses.mit;
  };
}
