{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b1";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "v${version}";
    sha256 = "06s8g4mzj08aaqph55kqj8xxixjd26sxzq96c53fblbjgn8x17mk";
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

