{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcoreaddons, kconfig, kdelibs4support, ktexteditor,
  qtwebkit
}:

mkDerivation {
  name = "umbrello";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ kcoreaddons kconfig kdelibs4support ktexteditor qtwebkit ];
}
