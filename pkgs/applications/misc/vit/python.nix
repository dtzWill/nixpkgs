{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0a1-2019-05-31";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "d8f5511945997d3e808867a7bae4a7382dcd40a2";
    sha256 = "1pv0022gmw6vnv8l62l0crw55jwxrbx9yby4h28kdm8kidili3fv";
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

