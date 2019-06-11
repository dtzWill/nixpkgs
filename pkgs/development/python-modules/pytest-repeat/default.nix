{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nbdmklpi0ra1jnfm032wz96y9nxdlcr4m9sjlnffwm7n4x43g2j";
  };

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Pytest plugin for repeating tests";
    homepage = https://github.com/pytest-dev/pytest-repeat;
    maintainers = with lib.maintainers; [ costrouc ];
    license = lib.licenses.mpl20;
  };
}
