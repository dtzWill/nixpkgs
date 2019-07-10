{ lib, fetchPypi, buildPythonPackage
, requests-async, pytest, pytest-asyncio }:

buildPythonPackage rec {
  pname = "joplin_api";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "139rq8sfbnhyp7z452aj6l6df9bvyh1dhvhlxdmdr0r2shdx6bdl";
  };

  checkInputs = [ pytest pytest-asyncio ];

  checkPhase = "py.test .";

  doCheck = false; # web clipper token (and running?)

  propagatedBuildInputs = [ requests-async ];

}
