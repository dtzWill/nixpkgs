{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.2.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rz2fn707x8ri507bb5k5y3di851dwchn0886f77g5bgiflmnpwm";
    extension = "zip";
  };

  buildInputs = [
    numpy
  ];

  checkInputs = [
    pytest
    pytestrunner
    glibcLocales
  ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  meta = {
    homepage = https://github.com/fonttools/fonttools;
    description = "A library to manipulate font files from Python";
    license = lib.licenses.mit;
  };
}
