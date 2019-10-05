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
  version = "unstable-2019-10-02";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "410d45f6eb60b8038a97fc97a441044229c65945";
    sha256 = "1arja0cxgxk242hvszzyz0gjnlgj5j5pa1m5fqif96wr4zyn99wc";
    fetchSubmodules = true;
  };

  #qmakeFlags = [ "CONFIG+=qtquickcompiler" "BUNDLE_FONT=true" ];

  postPatch = ''
    substituteInPlace src/spectraluser.cpp \
      --replace ', 0.7, 0.5, 1)' \
                ', 0.4, 0.4, 0.8)'
  '';

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
