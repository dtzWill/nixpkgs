{ stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, pytest
, pytestcov
}:

buildPythonPackage rec {
  pname = "html2text";
  version = "2019.9.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kwvpshz4ara9vpm66zgiy19bl7npncv0z1lbg6bb4r9biy0amkg";
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
