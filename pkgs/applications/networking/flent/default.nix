{ stdenv, buildPythonApplication, fetchFromGitHub, matplotlib, procps, pyqt5
, sphinx
}:

buildPythonApplication rec {
  pname = "flent";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "tohojo";
    repo = "flent";
    rev = "v${version}";
    sha256 = "16qvr4saphmf7y246bvc4w2h3dg0ghci18nw6fkl837sbrywwcd6";
  };

  buildInputs = [ sphinx ];

  checkInputs = [ procps ];

  propagatedBuildInputs = [
    matplotlib
    procps
    pyqt5
  ];

  # XXX: test_start_gui fails, with usual lack-of-wrapper error re:platform plugin
  # TODO: fix if possible, otherwise re-enable tests with just the one disabled
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The FLExible Network Tester";
    homepage = https://flent.org;
    license = licenses.gpl3;

    maintainers = [ maintainers.mmlb ];
  };
}
