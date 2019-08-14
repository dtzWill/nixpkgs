{ stdenv, fetchgit
, pkgconfig, makeWrapper
, cmake
, qtbase, qtquickcontrols2, qtmultimedia
, libpulseaudio
, qtkeychain
, cmark
# Not mentioned but seems needed
, qtgraphicaleffects
, qtdeclarative
, qtmacextras
, olm
}:

let
  # Following "borrowed" from yubikey-manager-qt
  qmlPath = qmlLib: "${qmlLib}/${qtbase.qtQmlPrefix}";

  inherit (stdenv) lib;

  qml2ImportPath = lib.concatMapStringsSep ":" qmlPath [
    qtbase.bin qtdeclarative.bin qtquickcontrols2.bin qtgraphicaleffects qtmultimedia
  ];

in stdenv.mkDerivation rec {
  pname = "spectral";
  #version = "648";
  version = "2019-08-14";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    #rev = "refs/tags/${version}";
    rev = "0067ce7e2ee92dedac5e1b0ee4e91241f2d49de3";
    sha256 = "1sb7ys597fls2rzyv9zwjjscxkb86qf6xdl9pjkf0mv4nc5vjfj8";
    fetchSubmodules = true;
  };

  postInstall = ''
    wrapProgram $out/bin/spectral \
      --set QML2_IMPORT_PATH "${qml2ImportPath}"
  '';

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  buildInputs = [ qtbase qtquickcontrols2 qtmultimedia qtkeychain qtgraphicaleffects qtdeclarative olm cmark ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isLinux libpulseaudio
    ++ stdenv.lib.optional stdenv.hostPlatform.isDarwin qtmacextras;

  meta = with stdenv.lib; {
    description = "A glossy client for Matrix, written in QtQuick Controls 2 and C++";
    homepage = https://gitlab.com/b0/spectral;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dtzWill ];
  };
}
