{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, glibcLocales }:

buildPythonPackage rec {
  pname = "urwid";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ndnhxd41m13darf5s0c6bafdpkzq1l6mfb04wbzdmyc1hg75h8";
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
