{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost, zeromq, rapidcheck
, zlib, miniupnpc, qtbase ? null, qttools ? null, wrapQtAppsHook ? null, utillinux, python3, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = if withGui then "bitcoin" else "bitcoind";
  version = "0.20.0";

  src = fetchurl {
    urls = [ "https://bitcoincore.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
             "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
             #"https://github.com/bitcoin/bitcoin/archive/v${version}.tar.gz"
           ];
    sha256 = "0a7vbv2cb0yhc8sp22jygp2n7w0zcgnw6kyw2m8q93c6xrc26npc";
  };

  nativeBuildInputs =
    [ pkgconfig autoreconfHook ]
    ++ optional withGui wrapQtAppsHook;
  buildInputs = [ openssl db48 boost zlib zeromq
                  miniupnpc libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib"
                     "--disable-bench"
                   ] ++ optionals (!doCheck) [
                     "--disable-tests"
                     "--disable-gui-tests"
                   ]
                     ++ optionals withGui [ "--with-gui=qt5"
                                            "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                          ];

  checkInputs = [ rapidcheck python3 ];

  doCheck = true;

  checkFlags =
    [ "LC_ALL=C.UTF-8" ]
    # QT_PLUGIN_PATH needs to be set when executing QT, which is needed when testing Bitcoin's GUI.
    # See also https://github.com/NixOS/nixpkgs/issues/24256
    ++ optional withGui "QT_PLUGIN_PATH=${qtbase}/${qtbase.qtPluginPrefix}";

  #enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    # bitcoin needs hexdump to build, which doesn't seem to build on darwin at the moment.
    platforms = platforms.linux;
  };
}
