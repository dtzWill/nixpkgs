{ lib, buildPythonPackage, fetchPypi, requests, httpcore
, black, isort, pytest, pytest-asyncio, pytestcov #, python-multipart
# Not packaged yet
#, starlette, uvicorn
}:

buildPythonPackage rec {
  pname = "requests-async";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vyy9mwdg6c4i22s3awhv8x11rcazhmhi5pxybn9cc9qa4244cc7";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpcore==0.3.*" \
                "httpcore==0.*"
  '';

  checkInputs = [ black isort pytest pytest-asyncio pytestcov ]; # python-multipart ];

  propagatedBuildInputs = [ requests httpcore ];
}
