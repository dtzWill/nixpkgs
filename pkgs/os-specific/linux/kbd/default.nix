{ stdenv, fetchurl, autoreconfHook,
  gzip, bzip2, pkgconfig, flex, check,
  pam, coreutils
}:

stdenv.mkDerivation rec {
  pname = "kbd";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1xz9hdghzv7px9ap3753h8qhl1k86d9y85ypzplqrcdkdxgvr891";
  };

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
  ];

  patches = [
    ./0001-configure.ac-respect-user-CFLAGS.patch
    ./0002-libkbdfile-Do-not-stop-on-the-first-error.patch
    # Includes binary files, and patch doesn't support git's binary diff
    # (and not worth manually applying or some such, IMHO)
    # ./0003-libkbdfile-Check-compression-suffix-even-if-the-suff.patch
    ./0004-searchpaths.patch
  ];

  postPatch =
    ''
      # Fix the path to gzip/bzip2.
      substituteInPlace src/libkbdfile/kbdfile.c \
        --replace gzip ${gzip}/bin/gzip \
        --replace bzip2 ${bzip2.bin}/bin/bzip2
    '';

  hardeningDisable = [ "format" ]; # analyze.l

  postInstall = ''
    for i in $out/bin/unicode_{start,stop}; do
      substituteInPlace "$i" \
        --replace /usr/bin/tty ${coreutils}/bin/tty
    done
  '';


  buildInputs = [ check pam ];
  nativeBuildInputs = [ autoreconfHook pkgconfig flex ];

  makeFlags = [ "setowner=" ];

  meta = with stdenv.lib; {
    homepage = ftp://ftp.altlinux.org/pub/people/legion/kbd/;
    description = "Linux keyboard utilities and keyboard maps";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
