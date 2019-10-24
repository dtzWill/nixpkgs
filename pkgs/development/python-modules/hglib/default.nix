{ stdenv, buildPythonPackage, fetchPypi, substituteAll, python, nose, mercurial, fetchpatch }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c1fa0cb4d332dd6ec8409b04787ceba4623e97fb378656f7cab0b996c6ca3b2";
  };

  patches = [
    (substituteAll {
      src = ./hgpath.patch;
      hg = "${mercurial}/bin/hg";
    })
    # for mercurial 5.1+
    (fetchpatch {
      url = "https://www.mercurial-scm.org/repo/python-hglib/raw-rev/12e6aaef0f6e";
      sha256 = "159pmhy23gqcc6rkh5jrni8fba4xbhxwcc0jf02wqr7f82kv8a7x";
    })
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} test.py --with-hg "${mercurial}/bin/hg"
  '';

  meta = with stdenv.lib; {
    description = "Mercurial Python library";
    homepage = "http://selenic.com/repo/python-hglib";
    license = licenses.mit;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };
}
