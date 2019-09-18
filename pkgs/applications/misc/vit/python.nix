{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b2-git";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "9960f135bb96142c517a865fd366aac855ecc414";
    sha256 = "1q0yvqq0q1afh1f2z218van9m1qzpnad235janb1lasif22sq3is";
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

