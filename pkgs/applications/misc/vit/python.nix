{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0a1-2019-06-10";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
    rev = "d9cc44de72689e53dd7b23f4364131c9b9575a39";
    sha256 = "10wfd7ypq9vbywfzymv2mk4mqfxrhwgjz1g3lig5cppsn7rziyba";
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

