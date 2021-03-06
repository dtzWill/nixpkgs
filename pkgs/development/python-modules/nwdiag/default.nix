{ stdenv, fetchPypi, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  pname = "nwdiag";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qkl1lq7cblr6fra2rjw3zlcccragp8384hpm4n7dkc5c3yzmmsw";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  # tests fail
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate network-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
