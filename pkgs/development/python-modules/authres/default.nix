{ stdenv, fetchPypi, buildPythonPackage, python }:

buildPythonPackage rec {
  pname = "authres";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb8c7e65ebb371ec70e7fb8226b13fc159b882a1ae70753384c4fe2040a7ac2f";
  };

  checkPhase = ''
    # run doctests
    ${python.interpreter} -m authres
  '';

  meta = with stdenv.lib; {
    description = "Email Authentication-Results Headers generation and parsing for Python/Python3";
    longDescription = ''
      Python module that implements various internet RFC's: 5451/7001/7601
      Authentication-Results Headers generation and parsing for
      Python/Python3.
    '';
    homepage = https://launchpad.net/authentication-results-python;
    license = licenses.bsd3;
    maintainers = with maintainers; [ leenaars ];
  };
}
