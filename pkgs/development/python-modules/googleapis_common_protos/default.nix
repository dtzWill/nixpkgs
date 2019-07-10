{ stdenv, buildPythonPackage, fetchPypi
, protobuf, six, pytest }:

buildPythonPackage rec {
  pname = "googleapis-common-protos";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1im0ad5vdyjagy1hwp5xlw67l35i3griayvfgi46p5vbwgaqw6z6";
  };

  propagatedBuildInputs = [ protobuf six ];
  checkInputs = [ pytest ];

  doCheck = false;  # there are no tests

  meta = with stdenv.lib; {
    description = "Common protobufs used in Google APIs";
    homepage = "https://github.com/googleapis/googleapis";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
