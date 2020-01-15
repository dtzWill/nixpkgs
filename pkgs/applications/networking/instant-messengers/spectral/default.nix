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
in stdenv.mkDerivation rec {
  pname = "spectral";
  version = "817";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "refs/tags/${version}";
    sha256 = "0lg0bkz621cmqb67kz1zmn4xwbspcqalz68byll5iszqz9y4gnp1";
    fetchSubmodules = true;
  };

  #qmakeFlags = [ "CONFIG+=qtquickcompiler" "BUNDLE_FONT=true" ];

  postPatch = ''
    substituteInPlace src/spectraluser.cpp \
      --replace ', 0.7, 0.5, 1)' \
                ', 1, 0.3, 1)'
  '';

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
