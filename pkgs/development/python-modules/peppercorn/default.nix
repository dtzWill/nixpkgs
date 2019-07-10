{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "peppercorn";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96d7681d7a04545cfbaf2c6fb66de67b29cfc42421aa263e4c78f2cbb85be4c6";
  };

  meta = with stdenv.lib; {
    description = "A library for converting a token stream into a data structure for use in web form posts";
    homepage = https://docs.pylonsproject.org/projects/peppercorn/en/latest/;
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.all;
  };

}
