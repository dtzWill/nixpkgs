{ stdenv, buildPythonPackage, fetchPypi, six, setuptools_scm, pytest }:
buildPythonPackage rec {
  pname = "python-dateutil";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g42w7k5007iv9dam6gnja2ry8ydwirh99mgdll35s12pyfzxsvk";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six setuptools_scm ];

  checkPhase = ''
    py.test dateutil/test
  '';

  # Requires fixing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = https://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
