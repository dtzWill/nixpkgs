{ mkDerivation, lib, fetchgit, cmake, pkgconfig
, extra-cmake-modules, qttools
, qtbase, qtdeclarative, qtsvg, qtimageformats
, qtquickcontrols, qtquickcontrols2
, qttranslations
, qtwayland, qtx11extras
, qtlocation
, qtgraphicaleffects
, qtmultimedia
, qtsensors
, qtxmlpatterns
, libsecret
# kde
, syntax-highlighting
}:

mkDerivation rec {
  pname = "opentodolist";
  version = "3.19.0";

  src = fetchgit {
    url = "https://gitlab.com/rpdev/opentodolist.git";
    rev = version;
    sha256 = "11vkslr63f9qvgy9fz6dzm47b1c8xjv7kkady3hk3k5an3875j6y";
  };

  postPatch = ''
    # Fix build from separate dir, let include paths do the work for finding header
    substituteInPlace lib/fileutils.cpp --replace '../datamodel/library.h' 'datamodel/library.h'

    # fix version gen, dunno
    cat > lib/opentodolist_version.h <<EOF
    #ifndef OPENTODOLIST_VERSION_H_
    #define OPENTODOLIST_VERSION_H_
    
    #define OPENTODOLIST_VERSION "${version}"
    
    #endif // OPENTODOLIST_VERSION_H_
    EOF
  '';

  nativeBuildInputs = [ cmake pkgconfig extra-cmake-modules qttools ];

  buildInputs = [
    qtbase qtdeclarative qtsvg qtimageformats qtquickcontrols qtquickcontrols2 qttranslations
    qtwayland qtx11extras
    qtlocation
    qtgraphicaleffects
    qtmultimedia
    qtsensors
    qtxmlpatterns
    syntax-highlighting libsecret
  ];

  cmakeFlags = [
    "-DOPENTODOLIST_FORCE_VERSION=${version}"
    "-DOPENTODOLIST_WITH_UPDATE_SERVICE=OFF"
    "-DOPENTODOLIST_WITH_APPIMAGE_EXTRAS=OFF"
  ];

  doCheck = false;
}
