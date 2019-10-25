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
, qtwebengine, qtwebkit # :( :( :(
, sqlite
}:

let
  qtkeychainWithLibsecret = qtkeychain.override {
    withLibsecret = true;
  };
in

mkDerivation rec {
  pname = "nextcloud-client";
  version = "unstable-2019-10-23";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    #rev = "v${version}";
    rev = "a8cf6e04439595a4ed2002ec40d7819ea7fcc86f"; # 2019-09-20
    sha256 = "1zp66s227xfy4hx3qdgsz2260qqx4xr4h4w3y46cdlkc3h6rp38i";
  };

  patches = [
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
    # ./no-webengine.patch
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
    qtkeychainWithLibsecret
    qttools
    qtwebengine qtwebkit
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
    # "-DNO_SHIBBOLETH=ON"
  ];

  meta = with lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
