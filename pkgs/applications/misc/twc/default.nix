{ lib, buildPythonApplication, fetchPypi,
tasklib, prompt_toolkit, attrs, mgcomm
}:

buildPythonApplication rec {
  pname = "twc";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vs2484mplwjsi17c2yb6ypfdj0ikh5nvgksdvxzp2x9nabqa5da";
  };

  buildInputs = [
    tasklib prompt_toolkit attrs mgcomm
  ];

  #meta = with lib; {
  #  description = "Taskwarrior Controller";
  #};

}
