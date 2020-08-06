{ lib, buildPythonPackage, fetchPypi, substituteAll, stdenv, setuptools_scm, freetype }:

buildPythonPackage rec {
  pname = "freetype-py";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yiqmdpzm1h2f9682bx9xmwhpj4d5sa8n8xjci5dav14qmmp2hyg";
    extension = "zip";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      freetype = "${freetype.out}/lib/libfreetype${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ freetype ];

  pythonImportsCheck =  [ "freetype" ];

  meta = with lib; {
    homepage = "https://github.com/rougier/freetype-py";
    description = "FreeType (high-level Python API)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
