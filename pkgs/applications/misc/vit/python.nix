{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0b2-git";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "b276fbc18fa314e949af59337dc3a289c8f1bc4f";
    sha256 = "0c8yzb8bl0dhyiilnsrhc19yb851spyhcmdfc21pgrnds50zlriv";
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

