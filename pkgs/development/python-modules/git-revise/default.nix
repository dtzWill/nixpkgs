{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, tox
, pytest
, pylint
, mypy
, black
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16sxmxksb5gjj6zfh1wy2czqj9nm4sd3j4fbrsphs8l065dzzikj";
  };

  disabled = !(pythonAtLeast "3.6");

  checkInputs = [ tox pytest pylint mypy black ];

  checkPhase = ''
    tox
  '';

  meta = with lib; {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = https://github.com/mystor/git-revise;
    license = licenses.mit;
    maintainers = with maintainers; [ emily ];
  };
}
