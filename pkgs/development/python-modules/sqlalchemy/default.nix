{ lib, fetchPypi, buildPythonPackage, isPy3k, isPy35
, mock
, pysqlite
, fetchpatch
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "SQLAlchemy";
  version = "1.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v74sl9xr5llv1q14hsn0wa9bwjcs5rjqmz1yphifiarvfsnh1qg";
  };

  checkInputs = [
    pytestCheckHook
    mock
  ] ++ lib.optional (!isPy3k) pysqlite;

  postInstall = ''
    sed -e 's:--max-worker-restart=5::g' -i setup.cfg
  '';

  dontUseSetuptoolsCheck = true;

  disabledTests = lib.optionals isPy35 [ "exception_persistent_flush_py3k "];

  patches = [
    # Two patches for sqlite 3.30 compatibility.
    # https://github.com/sqlalchemy/sqlalchemy/pull/4921
    (fetchpatch {
      url = https://github.com/sqlalchemy/sqlalchemy/commit/8b35ba54ab31aab13a34c360a31d014da1f5c809.patch;
      sha256 = "065csr6pd7j1fjnv72wbz8s6xhydi5f161gj7nyqq86rxkh0nl0n";
    })
    (fetchpatch {
      url = https://github.com/sqlalchemy/sqlalchemy/commit/e18534a9045786efdaf4963515222838c62e0300.patch;
      sha256 = "0bwfwp5gmgg12qilvwdd2a5xi76bllzzapb23ybh1k34c5pla195";
    })

  ];

  meta = with lib; {
    homepage = http://www.sqlalchemy.org/;
    description = "A Python SQL toolkit and Object Relational Mapper";
    license = licenses.mit;
  };
}
