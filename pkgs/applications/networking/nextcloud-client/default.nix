{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, wrapQtAppsHook, openssl_1_1, pcre, libsecret
, libcloudproviders, kdeFrameworks
}:

stdenv.mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.5.3";

  src = fetchgit {
    url = "git://github.com/nextcloud/desktop.git";
    rev = "refs/tags/v${version}";
    sha256 = "0fbw56bfbyk3cqv94iqfsxjf01dwy1ysjz89dri7qccs65rnjswj";
    fetchSubmodules = true;
  };

  patches = [ ./no-webengine.patch ];

  nativeBuildInputs = [ pkgconfig cmake wrapQtAppsHook ] ++ (with kdeFrameworks; [ extra-cmake-modules ]);

  buildInputs = [ qtbase qtkeychain qttools sqlite openssl_1_1.out pcre inotify-tools /* libcloudproviders */ ]
  ++ (with kdeFrameworks; [ kio kcoreaddons ]);

  enableParallelBuilding = true;

  NIX_LDFLAGS = "${openssl_1_1.out}/lib/libssl.so ${openssl_1_1.out}/lib/libcrypto.so";

  cmakeFlags = [
    "-UCMAKE_INSTALL_LIBDIR"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DOPENSSL_LIBRARIES=${openssl_1_1.out}/lib"
    "-DOPENSSL_INCLUDE_DIR=${openssl_1_1.dev}/include"
    "-DINOTIFY_LIBRARY=${inotify-tools}/lib/libinotifytools.so"
    "-DINOTIFY_INCLUDE_DIR=${inotify-tools}/include"

    # Disable this so qtwebkit isn't needed
    "-DNO_SHIBBOLETH=ON"
  ];

  qtWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libsecret ]}''
  ];

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
    $out/share/applications/nextcloud.desktop
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
