{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "python-doi";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lyyc54d41biy0676gjqhg8a8qhaarpwiszchyq20vc6mlnpyl0w";
  };

  meta = {
    description = "Python package to work with Document Object Identifier (doi)";
    homepage = https://github.com/papis/python-doi;
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
