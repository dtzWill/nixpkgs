{ lib
, buildPythonPackage
, fetchFromGitHub
, certifi
, hstspreload
, chardet
, h11
, h2
, idna
, rfc3986
, sniffio
, isPy27
, pytest
, pytestcov
, trustme
, uvicorn
, trio
, brotli
, urllib3
}:

buildPythonPackage rec {
  pname = "httpx";
  version = "0.11.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0p6d4a5g4r2vzms9l1zimqxglk7ifzi4jcfk57nfh5n6wcl5v1xj";
  };

  propagatedBuildInputs = [
    certifi
    hstspreload
    chardet
    h11
    h2
    idna
    rfc3986
    sniffio
    urllib3
  ];

  checkInputs = [
    pytest
    pytestcov
    trustme
    uvicorn
    trio
    brotli
  ];

  postPatch = ''
    substituteInPlace setup.py \
          --replace "h11==0.8.*" "h11"
  '';

  checkPhase = ''
    PYTHONPATH=.:$PYTHONPATH pytest
  '';

  meta = with lib; {
    description = "The next generation HTTP client";
    homepage = https://github.com/encode/httpx;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
