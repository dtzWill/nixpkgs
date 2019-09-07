{ stdenv, buildPythonPackage, fetchFromGitHub, fetchPypi, pyasn1, isPyPy, pytest }:

buildPythonPackage rec {
  pname = "pyasn1-modules";
  version = "0.2.6";

  #src = fetchFromGitHub {
  #  owner = "etingof";
  #  repo = pname;
  #  rev = "3d59f9af2158b2acd63dd213dad427f8e17dec16";
  #  sha256 = "0sng24d1rq1iasbbp0mfhys1l1ajdz3pmijnmq07an04s24jdhfg";
  #};
  # broken, use git for now
  src = fetchPypi {
    inherit pname version;
    sha256 = "08hph9j1r018drnrny29l7dl2q0cin78csswrhwrh8jmq61pmha3";
  };

  propagatedBuildInputs = [ pyasn1 ];

  checkInputs = [
    pytest
  ];

  # running tests through setup.py fails only for python2 for some reason:
  # AttributeError: 'module' object has no attribute 'suitetests'
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A collection of ASN.1-based protocols modules";
    homepage = https://pypi.python.org/pypi/pyasn1-modules;
    license = licenses.bsd3;
    platforms = platforms.unix;  # same as pyasn1
  };
}
