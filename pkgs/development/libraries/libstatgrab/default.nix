{ stdenv, fetchurl, pkgconfig
, ncurses
, IOKit ? null }:

stdenv.mkDerivation rec {
  pname = "libstatgrab";
  version = "0.92";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/${pname}/${pname}-${version}.tar.gz";
    sha256 = "15m1sl990l85ijf8pnc6hdfha6fqyiq74mijrzm3xz4zzxm91wav";
  };

  buildInputs = [ ncurses ] ++ stdenv.lib.optional stdenv.isDarwin IOKit;

  # perhaps limit this to musl
  NIX_CFLAGS_COMPILE = if stdenv.hostPlatform.isMusl then [ "-DLINUX" "-DHAVE_PROCFS" ] else null;

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://www.i-scream.org/libstatgrab/;
    description = "A library that provides cross platforms access to statistics about the running system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
