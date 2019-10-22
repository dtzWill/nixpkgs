{ stdenv, buildPythonPackage, fetchFromGitHub
, sqlite, isPyPy }:

buildPythonPackage rec {
  pname = "apsw";
  version = "3.29.0-r1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "rogerbinns";
    repo = "apsw";
    rev = version;
    sha256 = "1p3sgmk9qwd0a634lirva44qgpyq0a74r9d70wxb6hsa52yjj9xb";
  };

  buildInputs = [ sqlite ];

  meta = with stdenv.lib; {
    description = "A Python wrapper for the SQLite embedded relational database engine";
    homepage = https://github.com/rogerbinns/apsw;
    license = licenses.zlib;
  };
}
