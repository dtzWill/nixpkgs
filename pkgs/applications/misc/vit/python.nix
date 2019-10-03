{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "bf4cb069228e12b26e436b120fb9938a2b6a1531";
    sha256 = "0s5q05pq0pc7y5azkmmxbizh88mvsq8nc3cimj1mwi5v8il16q8l";
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

