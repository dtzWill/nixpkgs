{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0a1-2019-06-27";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "def0461c9fb65b200bc1c0ccb152bf077dbffdc6";
    sha256 = "12av13f3i237hhdpbnr32cgrw75sx078m29awx3f56zllm398smc";
  };

  propagatedBuildInputs = [
    future six tasklib tzlocal urwid
  ];

  checkInputs = [ glibcLocales ];

  preCheck = ''
    export TERM=linux
  '';

  meta = with lib; {
    license = licenses.mit;
  };
}

