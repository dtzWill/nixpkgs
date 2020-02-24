{ buildPythonPackage, fetchPypi, lib, isPy3k
, pkgconfig, igraph }:

buildPythonPackage rec {
  pname = "python-igraph";
  version = "0.8.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ igraph ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "13mbrlmnbgbzw6y8ws7wj0a3ly3in8j4l1ngi6yxvgvxxi4bprj7";
  };

  doCheck = !isPy3k;

  meta = {
    description = "High performance graph data structures and algorithms";
    homepage = "https://igraph.org/python/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.MostAwesomeDude ];
  };
}
