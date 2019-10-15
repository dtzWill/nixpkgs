{ stdenv, fetchgit
, pkgconfig, wrapQtAppsHook
, cmake
, qtbase, qttools, qtquickcontrols2, qtmultimedia, qtkeychain
, libpulseaudio
# Not mentioned but seems needed
, qtgraphicaleffects
, qtdeclarative
, qtmacextras
, olm, cmark
}:

let qtkeychain-qt5 = qtkeychain.override {
  inherit qtbase qttools;
  withQt5 = true;
};
in stdenv.mkDerivation {
  pname = "spectral";
  version = "unstable-2019-10-11";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "c666ffbba5aeb4b26ffe119480db700fee88ac38";
    sha256 = "12bz6k8igbvhiih7bf314sq8ylral3kc9h88kgpnk4ns9a0n2hqr";
    fetchSubmodules = true;
  };

  #qmakeFlags = [ "CONFIG+=qtquickcompiler" "BUNDLE_FONT=true" ];

  #postPatch = ''
  #  find . -name "*.qml" -exec sed -i 's@darker([^)]*, 1.1@\0 + 0.9@' '{}' +
  #'';
    #grep -r darker
    #exit 1

  nativeBuildInputs = [ pkgconfig cmake wrapQtAppsHook ];
  buildInputs = [ qtbase qtkeychain-qt5 qtquickcontrols2 qtmultimedia qtgraphicaleffects qtdeclarative olm cmark ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isLinux libpulseaudio
    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin qtmacextras;

  meta = with stdenv.lib; {
    description = "A glossy cross-platform Matrix client.";
    homepage = "https://gitlab.com/b0/spectral";
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dtzWill ];
  };
}
