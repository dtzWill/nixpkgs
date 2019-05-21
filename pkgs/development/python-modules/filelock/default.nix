{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "filelock";
  version = "3.0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ngzlvb5j8gqs2nxlp2b0jhzii792h66wsn694qm8kqixr225n0q";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/benediktschmitt/py-filelock;
    description = "A platform independent file lock for Python";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
