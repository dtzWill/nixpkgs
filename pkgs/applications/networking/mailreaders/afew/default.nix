{ stdenv, python3Packages, notmuch, fetchgit, git }:

python3Packages.buildPythonApplication rec {
  pname = "afew";
  version = "3.0.1";

  #src = fetchgit {
  #  url = "https://github.com/afewmail/afew";
  #  rev = "6664b457441dbcb752cabebba4631192b5fea8ec";
  #  sha256 = "1prm7093kbm526i9zwsydhrwqzmpw5k77nvyff43nvpjswxz25wf";
  #  leaveDotGit = true;
  #};
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0wpfqbqjlfb9z0hafvdhkm7qw56cr9kfy6n8vb0q42dwlghpz1ff";
  };

  nativeBuildInputs = with python3Packages; [ sphinx setuptools_scm git freezegun ];

  propagatedBuildInputs = [ notmuch python3Packages.notmuch ]
  ++ (with python3Packages; [
    setuptools chardet dkimpy
  ] ++ stdenv.lib.optional (!python3Packages.isPy3k) subprocess32);

  checkInputs = [ notmuch ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${notmuch}/bin"''
  ];

  outputs = [ "out" "doc" ];

  postBuild =  ''
    python setup.py build_sphinx -b html,man
  '';

  postInstall = ''
    install -D -v -t $out/share/man/man1 build/sphinx/man/*
    mkdir -p $out/share/doc/afew
    cp -R build/sphinx/html/* $out/share/doc/afew
  '';


  meta = with stdenv.lib; {
    outputsToInstall = outputs;
    homepage = https://github.com/afewmail/afew;
    description = "An initial tagging script for notmuch mail";
    license = licenses.isc;
    maintainers = with maintainers; [ andir flokli ];
  };
}
