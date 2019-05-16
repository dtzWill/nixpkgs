{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, nose
, decorator
}:

buildPythonPackage rec {
  pname = "networkx";
  # upgrade may break sage, please test the sage build or ping @timokau on upgrade
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "12swxb15299v9vqjsq4z8rgh5sdhvpx497xwnhpnb0gynrx6zra5";
  };

  broken = !isPy3k; # 2.3+ is py3-only

  checkInputs = [ nose ];
  propagatedBuildInputs = [ decorator ];

  meta = {
    homepage = "https://networkx.github.io/";
    description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
    license = lib.licenses.bsd3;
  };
}
