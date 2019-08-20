{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b2";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "v${version}";
    sha256 = "00c3lb3dp5ya1fnrfn1iq6brwzwl6qj2crrp3jc9ilsfag385xxp";
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

