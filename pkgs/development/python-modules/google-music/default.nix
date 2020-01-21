{ lib, buildPythonPackage, fetchPypi, pythonOlder
, appdirs
, audio-metadata
, google-music-proto
, protobuf
, requests_oauthlib
, tenacity
, httpx
}:

buildPythonPackage rec {
  pname = "google-music";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18bl44aaybkqlxxm7nprfp5n02kwljy7garsg5v4b31vqxjl1v7n";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "audio-metadata>=0.3,<0.4" "audio-metadata"
  '';

  propagatedBuildInputs = [
    appdirs
    audio-metadata
    google-music-proto
    httpx
    protobuf
    requests_oauthlib
    tenacity
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music;
    description = "A Google Music API wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
