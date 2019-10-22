{ lib, python3Packages, fetchFromGitHub, glibcLocales }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "scottkosty";
    repo = pname;
  #  rev = "v${version}";
    rev = "a6a48912a3e19d4bbadc5de5668f03652a187d0f";
    sha256 = "1qlbzwhyrgnv70hhllq4s3drs8aqns11n6fqp1f0jcffkv2clghc";
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

