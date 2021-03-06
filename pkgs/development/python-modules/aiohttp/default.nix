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
, freezegun
}:

buildPythonPackage rec {
  pname = "aiohttp";
  version = "3.6.2";

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
    sha256 = "09pkw6f1790prnrq0k8cqgnf1qy57ll8lpmc6kld09q7zw4vi6i5";
  };

  disabled = pythonOlder "3.5";

  checkInputs = [
    pytestrunner pytest gunicorn pytest-timeout async_generator pytest_xdist
    pytest-mock pytestcov trustme brotlipy freezegun
  ];

  propagatedBuildInputs = [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optionals (pythonOlder "3.7") [ idna-ssl typing-extensions ];

  # disable tests which attempt to do loopback connections
  checkPhase = ''
    cd tests
    pytest -k "not get_valid_log_format_exc \
               and not test_access_logger_atoms \
               and not aiohttp_request_coroutine \
               and not server_close_keepalive_connection \
               and not connector \
               and not client_disconnect \
               and not handle_keepalive_on_closed_connection \
               and not proxy_https_bad_response \
               and not partially_applied_handler \
               and not middleware" \
      --ignore=test_connector.py
  '';

  meta = with lib; {
    description = "Asynchronous HTTP Client/Server for Python and asyncio";
    license = licenses.asl20;
    homepage = https://github.com/aio-libs/aiohttp;
    maintainers = with maintainers; [ dotlambda ];
  };
}
