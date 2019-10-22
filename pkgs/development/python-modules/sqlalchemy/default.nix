{ lib, fetchPypi, buildPythonPackage, isPy3k, isPy35
, mock
, pysqlite
, pytest
, fetchpatch
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v74sl9xr5llv1q14hsn0wa9bwjcs5rjqmz1yphifiarvfsnh1qg";
  };

  patches = [
    # fix two tests started failing w/sqlite 3.30, using upstream PR (not merged!)
    (fetchpatch {
      url = "https://github.com/sqlalchemy/sqlalchemy/pull/4921.patch";
      sha256 = "0y37kjsfz7j82ic9fvc5cg5fj0yayr4v5mz3q3pd15j0vbljpci9";
    })
  ];

  checkInputs = [
    pytest
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  checkPhase = if isPy35 then ''
    pytest test -k 'not exception_persistent_flush_py3k'
  '' else ''
    pytest test
  '';

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
