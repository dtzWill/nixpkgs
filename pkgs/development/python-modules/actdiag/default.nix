{ stdenv, buildPythonPackage, fetchPypi
, pep8, nose, unittest2, docutils, blockdiag, reportlab }:

buildPythonPackage rec {
  pname = "actdiag";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g51v9dmdq18z33v332f1f0cmb3hqgaga5minj0mc2sglark1s7h";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  checkInputs = [ reportlab ];

  meta = with stdenv.lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
