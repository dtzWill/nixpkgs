{ buildPythonPackage
, lib
, fetchPypi
, mock
, pytest
, pytestrunner
, sh
, coverage
, docopt
, requests
, urllib3
, git
, isPy3k
}:

buildPythonPackage rec {
  pname = "coveralls";
  #name = "${pname}-python-${version}";
  version = "1.8.0";

  # wanted by tests
  src = fetchPypi {
    inherit pname version;
    sha256 = "0pcjz1vdary999f5sn1iz3nsvc6ygcz7wnbbh4497n40p5rhprf5";
  };

  checkInputs = [
    mock
    sh
    pytest
    git
  ];

  buildInputs = [
    pytestrunner
  ];

  # FIXME: tests requires .git directory to be present
  doCheck = false;

  checkPhase = ''
    python setup.py test
  '';

  propagatedBuildInputs = [
    coverage
    docopt
    requests
  ] ++ lib.optional (!isPy3k) urllib3;

  meta = {
    description = "Show coverage stats online via coveralls.io";
    homepage = https://github.com/coveralls-clients/coveralls-python;
    license = lib.licenses.mit;
  };
}


