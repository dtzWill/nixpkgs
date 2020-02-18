{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
}:

buildPythonPackage rec {
  pname = "decorator";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pi54wqj2p6ka13x7q8d5zgqg9bcf7m5d00l7x5bi204qmhn65c6";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/micheles/decorator/commit/3265f2755d16c0a3dfc9f1feee39722ddc11ee80.patch;
      sha256 = "1q5nmff30vccqq5swf2ivm8cn7x3lhz8c9qpj0zddgs2y7fw8syz";
    })
  ];

  meta = with lib; {
    homepage = https://pypi.python.org/pypi/decorator;
    description = "Better living through Python with decorators";
    license = lib.licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
