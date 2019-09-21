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
  pname = "elisa";
  #version = "0.4.2";
  version = "unstable-2019-09-19";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    #rev    = "v${version}";
    rev = "5e0c768598c16e42a73f67a7bf7c750fd2e09e2e";
    sha256 = "0np0s4rw943dpdjgpy0hsiz7ibdc2ha4zphyck9ljhrprwhr5pzv";
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
