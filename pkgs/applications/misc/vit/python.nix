{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b1.1";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    #rev = "v${version}";
    rev = "9f274bb24cc74911ae9f5c75d756e0a98ae97f52";
    sha256 = "0ybai7r7hwvjy8lrwmv1j9r2gh93lz6amsj6v1akvhiayv5aiqpp";
  };

  propagatedBuildInputs = [
    tasklib tzlocal urwid
  ];

  checkInputs = [ glibcLocales ];

  preCheck = ''
    export TERM=linux
  '';

  patches = [ ./no-columns.patch ];

  meta = with lib; {
    license = licenses.mit;
  };
}

