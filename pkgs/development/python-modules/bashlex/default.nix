{ lib
, buildPythonPackage
, fetchFromGitHub
, enum-compat
, nose
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "idank";
    repo = pname;
    rev = version;
    sha256 = "070spmbf53y18miky5chgky4x5h8kp9czkp7dm173klv9pi2cn0k";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ enum-compat ];

  checkPhase = ''
    python -m nose --with-doctest
  '';

  meta = with lib; {
    description = "Python parser for bash";
    license = licenses.gpl3;
    homepage = https://github.com/idank/bashlex;
    maintainers = with maintainers; [ multun ];
  };
}
