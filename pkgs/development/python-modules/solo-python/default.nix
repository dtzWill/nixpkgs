{ lib, buildPythonPackage, fetchFromGitHub
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.23";
  format = "flit";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "0r9cq0sd8pqnavgwa5cqgdxzbgly2baq8fpclnnz6anb2974kg3f";
  };

  # TODO: remove ASAP
  patchPhase = ''
    substituteInPlace pyproject.toml --replace "fido2 == 0.7.0" "fido2 >= 0.7.0"
  '';

  propagatedBuildInputs = [
    click
    ecdsa
    fido2
    intelhex
    pyserial
    pyusb
    requests
  ];

  meta = with lib; {
    description = "Python tool and library for SoloKeys";
    homepage = "https://github.com/solokeys/solo-python";
    maintainers = with maintainers; [ wucke13 ];
    license = with licenses; [ asl20 mit ];
  };
}
