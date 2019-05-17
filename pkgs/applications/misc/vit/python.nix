{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "pyt"; # err, "vit"?
  version = "2019-05-17";

  src = fetchFromGitHub {
    owner = "thehunmonkgroup";
    repo = pname;
    rev = "d6bc263118e87883c127a5c9036d009e9c862928";
    sha256 = "0g62dp3fircn4xd80h7hs3grvfg2if4pymvzsrsssa78hfrx00b3";
  };

  buildInputs = [
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

