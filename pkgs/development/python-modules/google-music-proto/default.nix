{ lib, buildPythonPackage, fetchPypi, pythonOlder
, attrs
, audio-metadata
, marshmallow
, pendulum
, protobuf
}:

buildPythonPackage rec {
  pname = "google-music-proto";
  version = "2.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dy5fhmfj28ca7kp5f6vfh7d9vp56y6rd1m1p06mc6wk76z706c3";
  };

  propagatedBuildInputs = [
    attrs
    audio-metadata
    marshmallow
    pendulum
    protobuf
  ];

  # No tests
  doCheck = false;

  disabled = pythonOlder "3.6";

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-proto;
    description = "Sans-I/O wrapper of Google Music API calls";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
