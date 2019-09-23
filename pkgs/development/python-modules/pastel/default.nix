{ lib, buildPythonPackage, fetchFromGitHub, pytest }:

buildPythonPackage rec {
  pname = "pastel";
  version = "0.1.1";

  # No tests in PyPi tarball
  src = fetchFromGitHub {
    owner = "sdispater";
    repo = "pastel";
    rev = version;
    sha256 = "1l906dakby2f8ybg6pc0z6v057idxhz2zm6valjm84clk9kv21pr";
  };

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest tests -sq
  '';

  meta = with lib; {
    homepage = https://github.com/sdispater/pastel;
    description = "Bring colors to your terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
