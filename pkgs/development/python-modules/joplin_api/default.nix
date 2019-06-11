{ lib, fetchPypi, buildPythonPackage
, requests-async }:

buildPythonPackage rec {
  pname = "joplin_api";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1111111111111111111111111111111111111111111111111111";
  };

  propagatedBuildInputs = [ requests-async ];

}
