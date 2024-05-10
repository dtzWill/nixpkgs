{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python
}:

buildPythonPackage rec {
  pname = "lit";
  version = "18.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5som6wqGrviMtnRhYQDjLRJQ0Fz+xMpXp0rKuwom3ng=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru = {
    inherit python;
  };

  # Non-standard test suite. Needs custom checkPhase.
  # Needs LLVM's `FileCheck` and `not`: `$out/bin/lit tests`
  # There should be `llvmPackages.lit` since older LLVM versions may
  # have the possibility of not correctly interfacing with newer lit versions
  doCheck = false;

  meta = {
    description = "Portable tool for executing LLVM and Clang style test suites";
    mainProgram = "lit";
    homepage = "http://llvm.org/docs/CommandGuide/lit.html";
    license = lib.licenses.ncsa;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}
