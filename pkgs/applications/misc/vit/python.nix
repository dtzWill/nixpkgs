{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "811c480ce9fa491cf419e04310bf49cbe7093e2d";
    sha256 = "12j5xazk0xhh7fnybvh7fx1aw915pmxd0c6az5k9r8x4iirrjagm";
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

