{ buildPythonPackage
, lib
, fetchPypi
, setuptools_scm
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "pluggy";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z76dbn5f7prvwaf2gnknf741bd4clym9hal71i7d5q5mi9a2988";
  };

  checkPhase = ''
    py.test
  '';

  # To prevent infinite recursion with pytest
  doCheck = false;

  buildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ importlib-metadata ];

  meta = {
    description = "Plugin and hook calling mechanisms for Python";
    homepage = "https://pypi.python.org/pypi/pluggy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
