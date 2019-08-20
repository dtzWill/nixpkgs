{ stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2019.8.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f516b9c10284174e2a974d86f91cab02b3cf983a17752075da751af0e895ef5e";
  };
  #src = fetchFromGitHub {
  #  owner = "Alir3z4";
  #  repo = pname;
  #  rev = "52bfc27e6a69e6f5e171b6035419c3c1457d864c";
  #  sha256 = "01c5c3vhy0jmcsfzbnb5pi8piw9ibnf3kvi6a0hka69fj1dc02sb";
  #};

  checkInputs = [ pytest pytestcov ];

  checkPhase = ''
    py.test -v test
  '';

  meta = with stdenv.lib; {
    description = "Turn HTML into equivalent Markdown-structured text";
    homepage = https://github.com/Alir3z4/html2text/;
    license = licenses.gpl3;
  };

}
