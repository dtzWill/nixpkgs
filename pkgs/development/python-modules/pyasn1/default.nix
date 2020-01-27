{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fnhbi3rmk47l9851gbik0flfr64vs5j0hbqx24cafjap6gprxxf";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
