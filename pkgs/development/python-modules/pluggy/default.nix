{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10511a54dvafw1jrk75mrhml53c7b7w4yaw7241696lc2hfvr895";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
