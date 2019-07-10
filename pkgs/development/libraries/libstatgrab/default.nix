{ stdenv, fetchurl, autoreconfHook, pkgconfig
, ncurses
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "libstatgrab-0.91";

  src = fetchurl {
    url = "http://ftp.i-scream.org/pub/i-scream/libstatgrab/${name}.tar.gz";
    sha256 = "1azinx2yzs442ycwq6p15skl3mscmqj7fd5hq7fckhjp92735s83";
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
