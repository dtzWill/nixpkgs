{ stdenv, buildPythonPackage, fetchpatch, fetchPypi
, cachetools
, flask
, freezegun
, mock
, oauth2client
, pyasn1-modules
, pytest
, pytest-localserver
, requests
, responses
, rsa
, setuptools
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fyav36d26lz08siws82qc9rxcy18mn7drf7zqghcs89pg9r1cyn";
  };

  propagatedBuildInputs = [ six pyasn1-modules cachetools rsa setuptools ];

  checkInputs = [
    flask
    freezegun
    mock
    oauth2client
    pytest
    pytest-localserver
    requests
    responses
    urllib3
  ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Google Auth Python Library";
    longDescription = ''
      This library simplifies using Google’s various server-to-server
      authentication mechanisms to access Google APIs.
    '';
    homepage = "https://github.com/googleapis/google-auth-library-python";
    changelog = "https://github.com/googleapis/google-auth-library-python/blob/v${version}/CHANGELOG.md";
    # Documentation: https://googleapis.dev/python/google-auth/latest/index.html
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
