{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b1";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    #rev = "v${version}";
    rev = "db1a4a08900728647db44b2b6a3cc40196c85b98";
    sha256 = "12i35fa7fymz74ljnw1ypns2l61p95d3a7lrplvb0fmmi341kcp9";
  };

  propagatedBuildInputs = [
    tasklib tzlocal urwid
  ];

  checkInputs = [ glibcLocales ];

  preCheck = ''
    export TERM=linux
  '';

  meta = with lib; {
    license = licenses.mit;
  };
}

