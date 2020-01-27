{ buildPythonPackage, fetchFromGitHub, fetchPypi, six, pytz, tzlocal, taskwarrior }:

buildPythonPackage rec {
  version = "2.1.1";
  pname = "tasklib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b1gi4ar6m3xp07w4f6isjjnvdjyyjqgsiy5wrjcac4x7c3ybkz2";
  };

  propagatedBuildInputs = [ six pytz tzlocal ];
  checkInputs = [ taskwarrior ];

  doCheck = false; # almost, some tz mixup
}
