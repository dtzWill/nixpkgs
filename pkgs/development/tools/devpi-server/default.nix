 { stdenv, python3Packages, nginx }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "devpi-server";
  version = "5.2.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1dapd0bis7pb4fzq5yva7spby5amcsgl1970z5nq1rlprf6qbydg";
  };

  propagatedBuildInputs = with python3Packages; [
    appdirs
    devpi-common
    execnet
    itsdangerous
    passlib
    pluggy
    pyramid
    strictyaml
    waitress
  ];

  checkInputs = with python3Packages; [
    beautifulsoup4
    mock
    nginx
    pytest
    pytest-flakes
    pytestpep8
    webtest
  ];

  # test_genconfig.py needs devpi-server on PATH
  checkPhase = ''
    PATH=$PATH:$out/bin pytest ./test_devpi_server --slow -rfsxX
  '';

  meta = with stdenv.lib;{
    homepage = http://doc.devpi.net;
    description = "Github-style pypi index server and packaging meta tool";
    license = licenses.mit;
    maintainers = with maintainers; [ makefu ];
  };
}
