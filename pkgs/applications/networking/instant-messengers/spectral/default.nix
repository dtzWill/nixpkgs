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
  version = "unstable-2020-07-28";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "d6009479a5cea4a9b5abcfacaa205eb9c8bf851c";
    sha256 = "10lvm1xynl5570mn15c1fbww9609zn39fm686qxfz3lv338hh7n2";
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
