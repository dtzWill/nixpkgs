{ mkDerivation, lib,
  pkgconfig, extra-cmake-modules,
  qtbase, qtx11extras, qtquickcontrols2,
  kiconthemes, kconfig, kconfigwidgets,
  kirigami2
}:

mkDerivation {
  name = "qqc2-desktop-style";
  nativeBuildInputs = [ pkgconfig extra-cmake-modules ];
  buildInputs = [
    qtbase qtx11extras qtquickcontrols2
    kiconthemes kconfig kconfigwidgets
    kirigami2
  ];
}
