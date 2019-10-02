{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytest
, pytestrunner
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k9id6d3m1g3mdh5d48lsvs3lr7sw7i5lgl2kw6kxlyynjszd6xv";
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
