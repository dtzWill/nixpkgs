{ mkDerivation, lib, fetchgit, qmake, pkgconfig
, extra-cmake-modules, qttools
, qtbase, qtdeclarative, qtsvg, qtimageformats
, qtquick1
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
  version = "3.19.1";

  src = fetchgit {
    url = "https://gitlab.com/rpdev/opentodolist.git";
    rev = version;
    sha256 = "0h8q10q5nrndwg7f2pw7cp8a1dwbrfsfk0rfg83zsysmg5qpksjz";
  };

  patches = [
    ./cmake-account-fix.patch
    ./cmake-translations-fix.patch
  ];

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

    # Disable test borked
    substituteInPlace test/CMakeLists.txt \
      --replace "add_subdirectory(application)" ""
  '';

  nativeBuildInputs = [ qmake pkgconfig qttools ];

  buildInputs = [
    qtbase qtdeclarative qtsvg qtimageformats
    qtquick1
    qtquickcontrols qtquickcontrols2
    qttranslations
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

  qmakeFlags = [
    "INSTALL_ROOT=${placeholder "out"}"
    "INSTALL_PREFIX=${placeholder "out"}"
  ];
}
