{ lib, fetchPypi, buildPythonPackage
, requests-async }:

buildPythonPackage rec {
  pname = "joplin_api";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "139rq8sfbnhyp7z452aj6l6df9bvyh1dhvhlxdmdr0r2shdx6bdl";
  };

  propagatedBuildInputs = [ requests-async ];

}
