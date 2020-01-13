{ lib, buildPythonPackage, fetchFromGitHub
, click, ecdsa, fido2, intelhex, pyserial, pyusb, requests}:

 buildPythonPackage rec {
  pname = "solo-python";
  version = "0.0.21";
  format = "flit";

  src = fetchFromGitHub {
    owner = "solokeys";
    repo = pname;
    rev = version;
    sha256 = "07r451dp3ma1mh735b2kjv86a4jkjhmag70cjqf73z7b61dmzl1q";
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
