{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, glibcLocales }:

buildPythonPackage (rec {
  pname = "urwid";
  version = "2019-05-16";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "6087e88daea4d042144f8cd674545f6e31dd8158";
    sha256 = "11q4xyyf2cvj3l405pkhhmsa8qw69wd6a373yp3gv1fr5k7qfz70";
  };

  #propagatedBuildInputs = [ glibcLocales ];
  checkInputs = [ glibcLocales ];

  meta = with stdenv.lib; {
    description = "A full-featured console (xterm et al.) user interface library";
    homepage = http://excess.org/urwid;
    repositories.git = git://github.com/wardi/urwid.git;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ garbas ];
  };
})
