{ lib, fetchPypi, buildPythonPackage, requests, zeroconf, protobuf, casttube, isPy3k }:

buildPythonPackage rec {
  pname = "PyChromecast";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0745bj6hz30g9scipbj536acvzkphmvvgkjfyrwnklxzk16ri7r4";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ requests zeroconf protobuf casttube ];

  meta = with lib; {
    description = "Library for Python 3.4+ to communicate with the Google Chromecast";
    homepage    = https://github.com/balloob/pychromecast;
    license     = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
    platforms   = platforms.unix;
  };
}
