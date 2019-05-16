{ buildPythonPackage, fetchPypi, lib, ujson, email_validator }:

buildPythonPackage rec {
  pname = "pydantic";
  version = "0.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2203e01c1d87a3d964aa0db56efdb1b89a90eca610ab3f0ddea396e2a5fa4cc4";
  };

  buildInputs = [ ujson email_validator ];

  meta = with lib; {
    description = "Data validation and settings management using python type hinting";
    homepage = https://pydantic-docs.helpmanual.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
