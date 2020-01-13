{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "publicsuffix";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1adx520249z2cy7ykwjr1k190mn2888wqn9jf8qm27ly4qymjxxf";
  };


  # disable test_fetch and the doctests (which also invoke fetch)
  patchPhase = ''
    sed -i -e "/def test_fetch/i\\
    \\t@unittest.skip('requires internet')" -e "/def additional_tests():/,+1d" tests.py
  '';

  meta = with stdenv.lib; {
    description = "Allows to get the public suffix of a domain name";
    homepage = "https://pypi.python.org/pypi/publicsuffix/";
    license = licenses.mit;
  };
}
