{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "httplib2";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i20lsc4h9rqxjf4lbc0p0r4saxw6zd8dbbhwaf1ywngzz0ch0b9";
  };

  # Needs setting up
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/httplib2/httplib2";
    description = "A comprehensive HTTP client library";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
