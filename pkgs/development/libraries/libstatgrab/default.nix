{ stdenv, fetchurl, autoreconfHook, pkgconfig
, ncurses
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "libstatgrab-0.92";

  src = fetchurl {
    url = "https://ftp.i-scream.org/pub/i-scream/libstatgrab/${name}.tar.gz";
    sha256 = "15m1sl990l85ijf8pnc6hdfha6fqyiq74mijrzm3xz4zzxm91wav";
  };

  buildInputs = [ ncurses ] ++ stdenv.lib.optional stdenv.isDarwin IOKit;

  # perhaps limit this to musl
  NIX_CFLAGS_COMPILE = [ "-DLINUX" "-DHAVE_PROCFS" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  patches = [ ./configure-musl.patch ./os_info-musl.patch ];
  patchFlags = [ "-p0" ];

  configureFlags = [ "ac_cv_header_sys_sysinfo_h=no" ];

  meta = with stdenv.lib; {
    homepage = https://www.i-scream.org/libstatgrab/;
    description = "A library that provides cross platforms access to statistics about the running system";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
