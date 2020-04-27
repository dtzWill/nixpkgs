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
  #version = "817";
  version = "unstable-2020-03-21";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "1f95e8888a70000d10317f29c76eb24287bd7390";
    sha256 = "16q0gmbnc305d6sg6z1ncriivy1qqvbhzka3a655bjcvrbs5v48w";
    fetchSubmodules = true;
  };

  patches = [ ./hsluv.patch /* TODO: fetch, this includes hsluv source entirely O:) */ ];

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
