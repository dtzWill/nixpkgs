{ stdenv, buildPythonPackage, fetchPypi, }:

buildPythonPackage rec {
  pname = "pyasn1";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11mwdsvrbwvjmny40cxa76h81bbc8jfr1prvw6hw7yvg374xawxp";
  };

  meta = with stdenv.lib; {
    description = "ASN.1 tools for Python";
    homepage = http://pyasn1.sourceforge.net/;
    license = "mBSD";
    platforms = platforms.unix;  # arbitrary choice
  };
}
