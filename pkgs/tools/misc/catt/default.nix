{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "catt";
  version = "0.7.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0qbcxyx5xlcwljm0cxasqww5vvjl2vq89xw4w2mvg0za3qnj8p56";
  };

  propagatedBuildInputs = with python3.pkgs; [ youtube-dl netifaces click PyChromecast requests ];

  doCheck = false; # requires network access

  meta = {
    description = "Allows you to send videos from many, many online sources to your Chromecast";
    homepage = https://github.com/skorokithakis/catt;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
