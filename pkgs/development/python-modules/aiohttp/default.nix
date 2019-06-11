{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, attrs
, chardet
, multidict
, async-timeout
, yarl
, idna-ssl
, typing-extensions
, pytestrunner
, pytest
, gunicorn
, pytest-timeout
, async_generator
, pytest_xdist
, pytestcov
, pytest-mock
, trustme
, brotlipy
, twine
, cython
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.5.4";

  #src = fetchFromGitHub {
  #  owner = "aio-libs";
  #  repo = pname;
  #  fetchSubmodules = true;
  #  #rev = "v${version}";
  #  rev = "34478be1a6e953cadb7e91cdfd01f6965d4a7b99";
  #  sha256 = "00xflcpm7ax69768hg7m1xx56g70wy4mqwv5abh5c03jimvz5d7k";
  #};
  src = fetchPypi {
    inherit pname version;
    sha256 = "9c4c83f4fa1938377da32bc2d59379025ceeee8e24b89f72fcbccd8ca22dc9bf";
  };

  disabled = pythonOlder "3.5";

  nativeBuildInputs = [ cython ];

  checkInputs = [
    pytestrunner pytest gunicorn pytest-timeout async_generator pytest_xdist
    pytest-mock pytestcov trustme brotlipy twine
  ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optionals (pythonOlder "3.7") [ idna-ssl typing-extensions ];

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
