{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols, qtquickcontrols2, qtwebsockets, qtgraphicaleffects
, qtbase, qtsvg
, kconfig, kconfigwidgets, kcmutils, kio, kcrash, kdeclarative, kfilemetadata, kinit, kxmlgui
, kirigami2, kdbusaddons
, baloo, vlc
, qqc2-desktop-style
}:

mkDerivation rec {
  name = "elisa-${version}";
  #version = "0.4.2";
  version = "unstable-2019-09-08";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    #rev    = "v${version}";
    rev = "a1ca107d948fff02d4b7e58cb12f1b03843f1e36";
    sha256 = "1p83sh2jab6cqnr0adhr64kmgs64gmpz6yh9jrr10akm44cb4nnq";
  };

  buildInputs = [ vlc ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools /* wrapGAppsHook */ ];

  propagatedBuildInputs = [
    qtmultimedia qtquickcontrols qtquickcontrols2 qtwebsockets qtgraphicaleffects
    qtbase qtsvg
    kconfig kconfigwidgets kcmutils kio kcrash kdeclarative kfilemetadata kinit kxmlgui
    kirigami2 kdbusaddons
    baloo vlc
    qqc2-desktop-style
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Elisa Music Player";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
