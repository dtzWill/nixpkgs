{ buildPythonPackage, fetchFromGitHub, fetchPypi, six, pytz, tzlocal, taskwarrior }:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "tasklib";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gr7b4h0qyp3waxbd48rk4s2b4yhd5zbdpcaf3icavgqhxzgnr1r";
  };

  propagatedBuildInputs = [ six pytz tzlocal ];
  checkInputs = [ taskwarrior ];

  #doCheck = false; # almost, some tz mixup
}
