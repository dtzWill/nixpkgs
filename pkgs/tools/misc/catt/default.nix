{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "catt";
  version = "0.6.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1mwgb442w12mwhn1qjj7d1l2vhji74qp07py6aghkpjm42x76dzh";
  };

  propagatedBuildInputs = with python3.pkgs; [ youtube-dl click PyChromecast ];

  doCheck = false; # requires network access

  meta = {
    description = "Allows you to send videos from many, many online sources to your Chromecast";
    homepage = https://github.com/skorokithakis/catt;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
