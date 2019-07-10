{ stdenv, fetchgit, cmake, pkgconfig, qtbase, qtwebkit, qtkeychain, qttools, sqlite
, inotify-tools, makeWrapper, openssl_1_1, pcre, libsecret, fetchpatch
, libcloudproviders, kdeFrameworks
}:

stdenv.mkDerivation rec {
  pname = "nextcloud-client";
  version = "2.5.3-rc1-unstable"; # 2";

  src = fetchgit {
    url = "git://github.com/nextcloud/desktop.git";
    #rev = "refs/tags/v${version}";
    rev = "419b8a3ff9af8d634241b76db56a5aece4e6f7ea";
    sha256 = "04pzzaknm8fvmfqk9vn6197dnfis0vl3126vwdkc1pi1rrq7izvs";
    fetchSubmodules = true;
  };

  patches = [ ./no-webengine.patch ];

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ] ++ (with kdeFrameworks; [ extra-cmake-modules ]);

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

  postInstall = ''
    sed -i 's/\(Icon.*\)=nextcloud/\1=Nextcloud/g' \
    $out/share/applications/nextcloud.desktop

    wrapProgram "$out/bin/nextcloud" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libsecret ]} \
      --prefix QT_PLUGIN_PATH : ${qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with stdenv.lib; {
    description = "Nextcloud themed desktop client";
    homepage = https://nextcloud.com;
    license = licenses.gpl2;
    maintainers = with maintainers; [ caugner ma27 ];
    platforms = platforms.linux;
  };
}
