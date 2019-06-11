{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pytest-flake8
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hsv4zwy1pwnbrr63wjjkpwrmnk36ngbkkqw01bj5hcwh1z3m56a";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest pytest-flake8 ];

  checkPhase = ''
    pytest
  '';
  doCheck = false; # dep cycle w/pytest b/c lameness, TODO: better solution

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = https://github.com/jaraco/zipp;
    license = licenses.mit;
  };
}
