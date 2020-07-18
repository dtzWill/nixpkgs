{ stdenv
, buildPythonPackage
, fetchFromGitHub
, urwid
, mock
, glibcLocales
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  #version  = "1.0.2.1"; # not really
  version  = "1.0.3";

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    rev = version;
    sha256 = "1y1vysx7jg0vbrarlsykhf7nmr8fc6k1fva1q3i98xq2m30s6r68";
  };

  checkInputs = [ glibcLocales ];
  propagatedBuildInputs = [ urwid mock ];

  meta = with stdenv.lib; {
    description = "Tree widgets for urwid";
    homepage = "https://github.com/pazz/urwidtrees";
    license = licenses.gpl3;
  };

}
