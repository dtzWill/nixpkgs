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
  version = "unstable-2019-10-14";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    #rev = "v${version}";
    rev = "f422a63200c00d8f8c9bd7228b6c482f1d93ff32"; # 2019-09-20
    sha256 = "1x3af36nb51q06mx3mnkv5s1vzk3v4lf0af1w3yqqddzma7dsv6j";
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
