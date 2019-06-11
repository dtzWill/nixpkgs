{ lib, buildPythonPackage, fetchPypi
, certifi, chardet, h11, h2, idna, rfc3986
}:

buildPythonPackage rec {
  pname = "httpcore";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dgkjnx07db223dzbf62w8y3c787spf0cb9r3lckb1ads87bp9k4";
  };

  # Optimistically allow newer h11 than the 0.8 it requests
  postPatch = ''
    substituteInPlace setup.py \
      --replace "h11==0.8.*" \
                "h11==0.9.*"
  '';

  propagatedBuildInputs = [
    certifi chardet h11 h2 idna rfc3986
  ];
}
