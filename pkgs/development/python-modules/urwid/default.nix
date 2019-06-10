{ stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch, glibcLocales }:

buildPythonPackage (rec {
  pname = "urwid";
  version = "2019-05-20";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "06986ccdbfa2645a8a075ebfb35b217bdc602a95";
    sha256 = "1w8qy0hbj2ws5b2a7n5nw4kyw411w0c3z582ysf6nwzklx3c0za9";
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
