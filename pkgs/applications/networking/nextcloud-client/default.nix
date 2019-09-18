{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, inotify-tools
, kdeFrameworks
, libcloudproviders
, libsecret
, openssl
, pcre
, pkgconfig
, qtbase
, qtkeychain
, qttools
, sqlite
}:

mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.5.3-git";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    #rev = "v${version}";
    rev = "179bbffd761292fa8fd1ebf0c17b312c92b48911";
    sha256 = "1hyg677f051z3hyhbh68gz1v2g7592vid40w5ljp0d3d0f1a9a8w";
  };

  patches = [
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
    ./no-webengine.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
    kdeFrameworks.extra-cmake-modules
  ];

  buildInputs = [
    inotify-tools
    libcloudproviders
    openssl
    pcre
    qtbase
    qtkeychain
    qttools
    sqlite
    kdeFrameworks.kio
    kdeFrameworks.kcoreaddons
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH

    # Disable this so qtwebkit isn't needed
    "-DNO_SHIBBOLETH=ON"
  ];

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
