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
  version = "unstable-2019-10-29";

  src = fetchFromGitHub {
    owner  = "KDE";
    repo   = "elisa";
    #rev    = "v${version}";
    rev = "e27340c3c0e9ebe33099af11ae7550bd8612fcbe";
    sha256 = "1pj6b3npdqcadgsj4hl9k3pmami0aj5m35i50i1bbi0r4izxpqk8";
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
