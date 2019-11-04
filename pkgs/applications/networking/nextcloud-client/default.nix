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
  version = "unstable-2019-10-28";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    #rev = "v${version}";
    rev = "09c282d9ead388ae773746f9077eee92f2261b8b"; # 2019-09-20
    sha256 = "1fd76j4zmxa67qfh7jkq68fy24q3awsbwxgyllfi6i3jnx8wp4y3";
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
