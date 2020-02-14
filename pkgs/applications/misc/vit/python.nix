{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "5456d280a049021331c942458b5d23f35a7914f8";
    sha256 = "0jakf2gqkhmpgjx9m7kpjn6mn5j5sr20y9388fxwbirjd6pfyy9r";
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

