{ stdenv, python3Packages, notmuch, fetchgit, git }:

python3Packages.buildPythonApplication rec {
  pname = "afew";
  version = "2.0.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0j60501nm242idf2ig0h7p6wrg58n5v2p6zfym56v9pbvnbmns0s";
  };
  #src = pythonPackages.fetchPypi {
  #  inherit pname version;
  #  sha256 = "0105glmlkpkjqbz350dxxasvlfx9dk0him9vwbl86andzi106ygz";
  #};

  nativeBuildInputs = with python3Packages; [ sphinx setuptools_scm git ];

  propagatedBuildInputs = with python3Packages; [
    python3Packages.notmuch chardet dkimpy
  ];

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
    maintainers = with maintainers; [ garbas andir flokli ];
  };
}
