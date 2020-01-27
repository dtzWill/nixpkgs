{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "google-music-scripts";
  version = "4.2.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "14cgwl5mhncm2skkjzidak8ki4rxk4zwn7s8i54c746cgyvairg1";
  };

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    audio-metadata
    google-music
    google-music-proto
    google-music-utils
    loguru
    pendulum
    natsort
    tomlkit
  ];

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/thebigmunch/google-music-scripts;
    description = "A CLI utility for interacting with Google Music";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
