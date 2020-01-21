{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, audio-metadata, multidict, wrapt
, pytest
}:

buildPythonPackage rec {
  pname = "google-music-utils";
  version = "2.2.1";

  # Pypi tarball doesn't contain tests
  src = fetchFromGitHub {
    owner = "thebigmunch";
    repo = "google-music-utils";
    rev = version;
    sha256 = "1kswlyz7k36plqh6ynwxvlal0p6f8r677zjp0qraqqf0dwk4qvgi";
  };

  propagatedBuildInputs = [
    audio-metadata multidict wrapt
  ];

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-utils;
    description = "A set of utility functionality for google-music and related projects";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
