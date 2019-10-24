{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-applehelp";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15rqmgphj4wqf4m5wnzxgmwxx5jwfzb0j0nb94ql0x5wnar0mapd";
  };

  # needs sphinx, but sphinx needs this!
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Extension which outputs Apple help books";
    homepage = http://sphinx-doc.org/;
    license = licenses.bsd2;
  };

}

