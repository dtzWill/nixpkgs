{ mkDerivation, fetchFromGitHub, lib
, extra-cmake-modules, kdoctools, wrapGAppsHook
, qtmultimedia, qtquickcontrols, qtquickcontrols2, qtwebsockets, qtgraphicaleffects
, qtbase, qtsvg
, kconfig, kconfigwidgets, kcmutils, kio, kcrash, kdeclarative, kfilemetadata, kinit, kxmlgui
, kirigami2, kdbusaddons
, baloo, vlc
}:

mkDerivation rec {
  name = "elisa-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    rev    = "v${version}";
    sha256 = "19qnsg792zjjj1vh1bqzx42rr8ysndvmraw1076ywbsbq8mp0i3k";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [
    qtmultimedia qtquickcontrols qtquickcontrols2 qtwebsockets qtgraphicaleffects
    qtbase qtsvg
    kconfig kconfigwidgets kcmutils kio kcrash kdeclarative kfilemetadata kinit kxmlgui
    kirigami2 kdbusaddons
    baloo vlc
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Elisa Music Player";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    inherit (kconfig.meta) platforms;
  };
}
