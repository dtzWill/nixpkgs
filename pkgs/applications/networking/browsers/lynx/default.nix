{ stdenv, buildPackages
, fetchurl, pkgconfig, ncurses, gzip
, sslSupport ? true, openssl ? null
, nukeReferences
}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation rec {
  name = "lynx-${version}";
  #version = "2.8.9rel.1";
  version = "2.9.0dev.1";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/lynx/tarballs/lynx${version}.tar.bz2"
      "https://invisible-mirror.net/archives/lynx/tarballs/lynx${version}.tar.bz2"
    ];
    sha256 = "1fgcr83dbh372n1hw8wp8kyjpbnjyrgmvkmlqv3qrhygr6ksy1x9";
  };

  enableParallelBuilding = true;

  hardeningEnable = [ "pie" ];

  configureFlags = [
    "--enable-default-colors"
    "--enable-widec"
    "--enable-ipv6"
  ] ++ stdenv.lib.optional sslSupport "--with-ssl";

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ nukeReferences ]
    ++ stdenv.lib.optional sslSupport pkgconfig;

  buildInputs = [ ncurses gzip ] ++ stdenv.lib.optional sslSupport openssl.dev;

  # cfg_defs.h captures lots of references to build-only dependencies, derived
  # from config.cache.
  postConfigure = ''
    make cfg_defs.h
    nuke-refs cfg_defs.h
  '';

  meta = with stdenv.lib; {
    description = "A text-mode web browser";
    homepage = https://lynx.invisible-island.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
