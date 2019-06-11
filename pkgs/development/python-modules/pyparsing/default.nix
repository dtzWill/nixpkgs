{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
    pname = "pyparsing";
    version = "2.4.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "0anb80c0sn7mjnrj6gs3by8yn34rzw0z5fj6jx78y4gw44rw0wqq";
    };

    # Not everything necessary to run the tests is included in the distribution
    doCheck = false;

    meta = with stdenv.lib; {
      homepage = https://github.com/pyparsing/pyparsing;
      description = "An alternative approach to creating and executing simple grammars, vs. the traditional lex/yacc approach, or the use of regular expressions";
      license = licenses.mit;
    };
}
