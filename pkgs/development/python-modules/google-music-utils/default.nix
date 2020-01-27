{ lib, buildPythonPackage, fetchPypi, pythonOlder
, audio-metadata, multidict, wrapt
, pytest
}:

buildPythonPackage rec {
  pname = "google-music-utils";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10x1m0cqnbpacp3r7zff01l8x2a97hgyqgx3ajs67x8462zkkz76";
  };

  propagatedBuildInputs = [
    audio-metadata multidict wrapt
  ];

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';
  doCheck = false; # none in pypi

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-utils;
    description = "A set of utility functionality for google-music and related projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
