{ buildPythonPackage, fetchPypi, lib, ujson, email_validator }:

buildPythonPackage rec {
  pname = "pydantic";
  version = "0.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mid11k20ypsbb75zssghrgg5wk1nja4g81dj2iriyq07hi3lpk2";
  };

  buildInputs = [ ujson email_validator ];

  meta = with lib; {
    description = "Data validation and settings management using python type hinting";
    homepage = https://pydantic-docs.helpmanual.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
