{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "orjson";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12cv4dz5m0samkv2kj1afa6hl26a8wl3k1qnqlbqk3gbvmb3ywx2";
  };

  format = "pyproject";
}
