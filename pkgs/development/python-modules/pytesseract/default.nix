{ buildPythonPackage, fetchPypi, lib, pillow, tesseract, substituteAll }:

buildPythonPackage rec {
  pname = "pytesseract";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lml55jrvdzy9fm31zpw64fqc4d6p5djg1ax2kgnimzfscxghh8h";
  };

  patches = [
    (substituteAll {
      src = ./tesseract-binary.patch;
      drv = "${tesseract}";
    })
  ];

  buildInputs = [ tesseract ];
  propagatedBuildInputs = [ pillow ];

  # the package doesn't have any tests.
  doCheck = false;

  meta = with lib; {
    homepage = https://pypi.org/project/pytesseract/;
    license = licenses.asl20;
    description = "A Python wrapper for Google Tesseract";
    maintainers = with maintainers; [ ma27 ];
  };
}
