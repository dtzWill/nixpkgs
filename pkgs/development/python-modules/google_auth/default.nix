{ stdenv, buildPythonPackage, fetchPypi
, pytest, mock, oauth2client, flask, requests, setuptools, urllib3, pytest-localserver, six, pyasn1-modules, cachetools, rsa, freezegun }:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zf0cvby63w7qrdmpy4390a46vj05ayp215figl59bsqdz2q1whh";
  };

  checkInputs = [ pytest mock oauth2client flask requests urllib3 pytest-localserver freezegun ];
  propagatedBuildInputs = [ six pyasn1-modules cachetools rsa setuptools ];

  # The removed test tests the working together of google_auth and google's https://pypi.python.org/pypi/oauth2client
  # but the latter is deprecated. Since it is not currently part of the nixpkgs collection and deprecated it will
  # probably never be. We just remove the test to make the tests work again.
  postPatch = ''rm tests/test__oauth2client.py'';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "This library simplifies using Google’s various server-to-server authentication mechanisms to access Google APIs.";
    homepage = "https://google-auth.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
