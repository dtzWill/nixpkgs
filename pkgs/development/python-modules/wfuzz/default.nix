{ buildPythonPackage
, chardet
, configparser
, fetchFromGitHub
, future
, isPy27
, lib
, mock
, netaddr
, pkgs
, pyparsing
, pycurl
, pytest
, six
}:

buildPythonPackage rec {
  pname = "wfuzz";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "xmendez";
    repo = pname;
    rev = "v${version}";
    sha256 = "03iswnffq9dx8n2b5xp4l2v9wchy4g20w3iaqmw883br6wcl7vdd";
  };

  buildInputs = [ pyparsing configparser ];

  propagatedBuildInputs = [
    chardet
    future
    pycurl
    six
  ];

  checkInputs = [ netaddr pytest ] ++ lib.optionals isPy27 [ mock ];

  # Skip tests requiring a local web server.
  checkPhase = ''
    HOME=$TMPDIR pytest \
      tests/test_{moduleman,filterintro,reqresp,api,clparser,dotdict}.py
  '';

  meta = with lib; {
    description = "Web content fuzzer, to facilitate web applications assessments";
    homepage = "https://wfuzz.readthedocs.io";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
