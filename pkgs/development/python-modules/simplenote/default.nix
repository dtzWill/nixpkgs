{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "simplenote";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cn4y4i82s0n9mzqkq1wx1gsbgqr3xrcmvihlpb0fjc0i9vvm841";
  };

  meta = {
    description = "Python library for the simplenote.com API";
    homepage = https://github.com/mrtazz/simplenote.py;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
