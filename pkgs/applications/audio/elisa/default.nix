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
  version = "unstable-2019-09-09";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    #rev    = "v${version}";
    rev = "7d815c9fa3803f06d592d9885fa8bf6031d51b7e";
    sha256 = "0hsdgmqldjfiwc3pdgck4s9i8pr2s37r6bm1hswgrgsb5hxx563s";
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
