{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "configparser";
  version = "3.7.5"; # 3.8.1 is avail, FWIW

  src = fetchPypi {
    inherit pname version;
    sha256 = "13kgding6zyvwzzcar6xhql8x4j6b4lpnf06waczjb9ph0q075ck";
  };

  # No tests available
  doCheck = false;

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with stdenv.lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = https://github.com/jaraco/configparser;
  };
}
