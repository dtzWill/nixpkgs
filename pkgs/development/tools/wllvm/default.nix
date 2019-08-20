{ stdenv, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.7";
  pname = "wllvm";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0bvmc0y6pyklbsxym7w4n2bpj429k5chljwgq7929c700pp34qbw";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/travitch/whole-program-llvm;
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
