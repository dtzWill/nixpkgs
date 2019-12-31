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
  version = "unstable-2019-12-23";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "5a154eab04db4966669b849a3642b29749f81be3";
    sha256 = "0b0r4bfl5ljyx74ny03s5gwiwbm7l62ycys2pqnis6qiphnkfid1";
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
