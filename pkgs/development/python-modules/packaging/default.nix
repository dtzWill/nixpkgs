{ stdenv, buildPythonPackage, fetchPypi
, pyparsing, six, pytest, pretend }:

buildPythonPackage rec {
  pname = "packaging";
  version = "19.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0izwlz9h0bw171a1chr311g2y7n657zjaf4mq4rgm8pp9lbj9f98";
  };

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [ pytest pretend ];

  checkPhase = ''
    py.test tests
  '';

  # Prevent circular dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Core utilities for Python packages";
    homepage = https://github.com/pypa/packaging;
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
