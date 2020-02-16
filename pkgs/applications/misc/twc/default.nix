{ lib, python3, fetchPypi }:

# TODO: refactor this into separate file, as it should be :)
let
  python = python3.override {
    packageOverrides = self: super: {
      mgcomm = super.buildPythonPackage rec {
        pname = "mgcomm";
        version = "0.2.0";
        src = fetchPypi {
          inherit pname version;
          sha256 = "007fc1s1filbf0xi4025p1bnd7shj85q9gki8s58vdrgy75081xk";
        };
        nativeBuildInputs = [ super.setuptools_scm ];
      };
    };
  };
in with python.pkgs; buildPythonApplication rec {
  pname = "twc";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vs2484mplwjsi17c2yb6ypfdj0ikh5nvgksdvxzp2x9nabqa5da";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'tasklib==1.1.0' 'tasklib' \
      --replace 'attrs==19.1.0' 'attrs' \
      --replace 'prompt_toolkit==2.0.9' 'prompt_toolkit'
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    tasklib prompt_toolkit attrs mgcomm
  ];

  #meta = with lib; {
  #  description = "Taskwarrior Controller";
  #};

}
