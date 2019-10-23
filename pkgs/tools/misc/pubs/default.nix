{ stdenv, fetchFromGitHub, python3Packages, git }:

python3Packages.buildPythonApplication rec {
  pname = "pubs";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    sha256 = "0npgsyxj7kby5laznk5ilkrychs3i68y57gphwk48w8k9fvnl3zc";
  };

  propagatedBuildInputs = with python3Packages; [
    argcomplete dateutil configobj feedparser bibtexparser pyyaml requests six beautifulsoup4
  ];

  nativeBuildInputs = [ git ];

  checkInputs = with python3Packages; [ pyfakefs mock ddt ];

  preCheck = ''
    # dummy config for tests
    export HOME=$TMPDIR
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  meta = with stdenv.lib; {
    description = "Command-line bibliography manager";
    homepage = https://github.com/pubs/pubs;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ gebner ];
  };
}
