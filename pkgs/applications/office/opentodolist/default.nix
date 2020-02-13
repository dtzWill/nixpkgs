{ mkDerivation, lib, fetchgit, cmake, pkgconfig, qtbase, qttools
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
  '';

  nativeBuildInputs = [ cmake pkgconfig qttools ];

  buildInputs = [ qtbase syntax-highlighting libsecret ];

  cmakeFlags = [
    "-DOPENTODOLIST_FORCE_VERSION=${version}"
    "-DOPENTODOLIST_WITH_UPDATE_SERVICE=OFF"
    "-DOPENTODOLIST_WITH_APPIMAGE_EXTRAS=OFF"
  ];
}
