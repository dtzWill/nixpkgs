{ stdenv, lib, buildPythonApplication, fetchFromGitHub, isPy3k, pexpect, urwid, toml, pydantic, poetry
, pytest, pytest-mock, coverage
 }:

buildPythonApplication rec {
  pname = "just-start";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AliGhahraei";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ddcjk5l9r3ksvp48xyb9ab8k8c2z4jyi5v60p7k4hr5frsjfja4";
  };

  format = "pyproject";

  buildInputs = [ poetry ];
  propagatedBuildInputs = [ pexpect urwid toml pydantic ];

  LC_ALL = "C.UTF-8";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [ pytest pytest-mock coverage ];
  doCheck = false;

  disabled = !isPy3k;

  meta = with lib; {
    description = "An app to defeat procrastination (terminal pomodoro w/taskwarrior)";
    license = licenses.gpl3;
    homepage = https://github.com/AliGhahraei/just-start;
    maintainers = with maintainers; [ dtzWill ];
  };
}
