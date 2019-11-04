{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchurl, fetchFromGitHub
, extra-cmake-modules, karchive, kcoreaddons, kwindowsystem, kcrash, knewstuff, libksysguard
, qtbase, qtquickcontrols, qtquickcontrols2, qtgraphicaleffects, qtdeclarative, qtx11extras }:

let
  # satisfy compile-time checks for runtime QML deps
  qmlPath = qmlLib: "${qmlLib}/${qtbase.qtQmlPrefix}";
  qml2ImportPath = lib.concatMapStringsSep ":" qmlPath [
    qtbase.bin qtdeclarative.bin qtquickcontrols qtquickcontrols2.bin qtgraphicaleffects plasma-framework
  ];
in
mkDerivation rec {
  pname = "latte-dock";
  version = "0.9.4";
  #version = "unstable-2019-09-11";
  name = "${pname}-${version}";

  #src = fetchFromGitHub {
  #  owner = "KDE";
  #  repo = pname;
  #  rev = "ac11a3a2d7d669d20ad16e8ce745032845704df1";
  #  sha256 = "16m4gixbdcnc7y94ayax8b9ih0sizgpvvbn8ckj939md8s85zz5i";
  #};
  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${name}.tar.xz";
    sha256 = "1vil1s1w10x1zsqjaid3mfa082kaiib2vfadi8a6hspdbjr0drx1";
    name = "${name}.tar.xz";
  };

  buildInputs = [
    plasma-framework
    xorg.libpthreadstubs xorg.libXdmcp xorg.libSM
    karchive kcoreaddons kcrash knewstuff libksysguard kwindowsystem
    qtbase qtx11extras qtquickcontrols qtquickcontrols2 qtgraphicaleffects qtdeclarative
  ];

  nativeBuildInputs = [
    cmake extra-cmake-modules
  ];

  # It seems that there is a bug in qtdeclarative: qmlplugindump fails
  # because it can not find or load the Qt platform plugin "minimal".
  # A workaround is to set QT_PLUGIN_PATH and QML2_IMPORT_PATH explicitly.
  QT_PLUGIN_PATH = "${qtbase.bin}/${qtbase.qtPluginPrefix}";
  QML2_IMPORT_PATH = "${qml2ImportPath}";

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = https://github.com/psifidotos/Latte-Dock;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley maintainers.ysndr ];
  };


}
