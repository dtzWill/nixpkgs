{ buildPythonPackage, lib, fetchPypi
, isPy3k
, requests
, pytest
}:

buildPythonPackage rec {
  pname = "pylibgen";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vmrg1vcvjxfdgbhh30bcwnjjsq8sqnjc840ngi146bwz8kqmcl7";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest ];

  # no tests in PyPI tarball
  doCheck = false;

  meta = {
    description = "Python interface to Library Genesis";
    homepage = https://pypi.org/project/pylibgen/;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
