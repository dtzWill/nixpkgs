{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kconfig, kdelibs4support, ktexteditor,
  qtwebkit, kdevelop-pg-qt, llvm # kdevelop "platform"?
}:

mkDerivation {
  name = "umbrello";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcoreaddons kconfig kdelibs4support ktexteditor qtwebkit kdevelop-pg-qt llvm ];
}
