{ stdenv, fetchFromGitHub, updateAutotoolsGnuConfigScriptsHook, autoreconfHook, ncurses, libpcap }:

stdenv.mkDerivation rec {
  pname = "iftop";
  version = "unstable-2018-10-03";

  src = fetchFromGitHub {
    owner = "dtzWill"; # upstream git has an expired cert, so for now use this
    repo = pname;
    rev = "77901c8c53e01359d83b8090aacfe62214658183";
    sha256 = "0wyhnxf2ph31hl1dhk230wj1vxr28wcihr4ww07jfanvcrv5m4f4";
  };

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".
  LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  patches = [ ./getnameinfo-is-okay-now.patch ];

  nativeBuildInputs = [ autoreconfHook updateAutotoolsGnuConfigScriptsHook ];

  CFLAGS = [ "-DUSE_GETIFADDRS=1" /* debian prefers this, must be set ourselves apparently */ ];

  buildInputs = [ ncurses libpcap ];

  meta = with stdenv.lib; {
    description = "Display bandwidth usage on a network interface";
    longDescription = ''
      iftop does for network usage what top(1) does for CPU usage. It listens
      to network traffic on a named interface and displays a table of current
      bandwidth usage by pairs of hosts.
    '';
    license = licenses.gpl2Plus;
    homepage = http://ex-parrot.com/pdw/iftop/;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
