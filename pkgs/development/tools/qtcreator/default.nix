{ stdenv, fetchurl, makeWrapper
, qtbase, qtquickcontrols, qtscript, qtdeclarative, qmake
, withDocumentation ? false
}:

with stdenv.lib;

let
  baseVersion = "4.9";
  revision = "1";
in

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "${baseVersion}.${revision}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/${pname}/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "10ddp1365rf0z4bs7yzc9hajisp3j6mzjshyd0vpi4ki126j5f3r";
  };

  buildInputs = [ qtbase qtscript qtquickcontrols qtdeclarative ];

  nativeBuildInputs = [ qmake makeWrapper ];

  patches = optional (stdenv.hostPlatform.isAarch32 || stdenv.hostPlatform.isAarch64) ./0001-Fix-Allow-qt-creator-to-build-on-arm-aarch32-and-aar.patch;

  doCheck = true;

  enableParallelBuilding = true;

  buildFlags = optional withDocumentation "docs";

  installFlags = [ "INSTALL_ROOT=$(out)" ] ++ optional withDocumentation "install_docs";

  preConfigure = ''
    substituteInPlace src/plugins/plugins.pro \
      --replace '$$[QT_INSTALL_QML]/QtQuick/Controls' '${qtquickcontrols}/${qtbase.qtQmlPrefix}/QtQuick/Controls'
  '';

  preBuild = optional withDocumentation ''
    ln -s ${getLib qtbase}/$qtDocPrefix $NIX_QT5_TMP/share
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/org.qt-project.qtcreator.desktop \
      --replace "Exec=qtcreator" "Exec=$out/bin/qtcreator"
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = https://wiki.qt.io/Category:Tools::QtCreator;
    license = "LGPL";
    maintainers = [ maintainers.akaWolf ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
  };
}
