{ stdenv, fetchPypi, buildPythonPackage, pep8, nose, unittest2, docutils
, pillow, webcolors, funcparserlib
}:

buildPythonPackage rec {
  pname = "blockdiag";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15r3fyx2v40crblyr1mwzsc6cn38m4mfi74rd449wk5lygcrv9hn";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ pillow webcolors funcparserlib ];

  # One test fails:
  #   ...
  #   FAIL: test_auto_font_detection (blockdiag.tests.test_boot_params.TestBootParams)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate block-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
