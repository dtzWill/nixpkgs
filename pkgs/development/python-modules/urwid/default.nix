{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, glibcLocales }:

buildPythonPackage rec {
  pname = "urwid";
  # version = "2.0.1";

  # src = fetchPypi {
  #   inherit pname version;
  #   sha256 = "1g6cpicybvbananpjikmjk8npmjk4xvak1wjzji62wc600wkwkb4";
  # };

  version = "2019-08-09";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "bb5498690bb59d1ce995a843f8de7349541e883d";
    sha256 = "0mdfrqbbwrw1pn8gi8dwa42bbsycy9lwyyw8f55xfzqgwhhjz96a";
  };

  #propagatedBuildInputs = [ glibcLocales ];
  checkInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ ];
  };
}
