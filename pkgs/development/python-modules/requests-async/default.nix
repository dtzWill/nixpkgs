{ lib, buildPythonPackage, fetchPypi, requests, httpcore
, black, isort, pytest, pytest-asyncio, pytestcov #, python-multipart
# Not packaged yet
#, starlette, uvicorn
}:

buildPythonPackage rec {
  pname = "requests-async";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wdxv7c5n7vryf036212g3mwpw3rfs616czk4fld5kg4zdq2v05v";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpcore==0.3.*" \
                "httpcore==0.*"
  '';

  checkInputs = [ black isort pytest pytest-asyncio pytestcov ]; # python-multipart ];

  propagatedBuildInputs = [ requests httpcore ];
}
