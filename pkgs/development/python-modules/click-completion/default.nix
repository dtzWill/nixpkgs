{ stdenv, buildPythonPackage, fetchPypi, isPy3k,
  click, jinja2, shellingham, six
}:

buildPythonPackage rec {
  pname = "click-completion";
  version = "0.5.2";
  disabled = (!isPy3k);

  src = fetchPypi {
    inherit pname version;
    sha256 = "11nfgggcmqv8blag7ydk051x21whfx81psdnj2hkirk72fw1dy2v";
  };

  propagatedBuildInputs = [ click jinja2 shellingham six ];

  meta = with stdenv.lib; {
    description = "Add or enhance bash, fish, zsh and powershell completion in Click";
    homepage = https://github.com/click-contrib/click-completion;
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
