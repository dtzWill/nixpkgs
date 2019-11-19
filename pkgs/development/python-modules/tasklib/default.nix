{ buildPythonPackage, fetchFromGitHub, fetchPypi, six, pytz, tzlocal, taskwarrior }:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "tasklib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19yra86g3wz2xgk22dnrjjh3gla969vb8jrps5rf0cdmsm9qqisv";
  };

  propagatedBuildInputs = [ six pytz tzlocal ];
  checkInputs = [ taskwarrior ];

  doCheck = false; # almost, some tz mixup
}
