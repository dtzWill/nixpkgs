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

mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.6.0-rc1";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "v${version}";
    sha256 = "0jsg7w6547yynh2ga43h1mx9ddjciw4y9nxwib9dw4icwq1r48nw";
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
    qtkeychain
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
