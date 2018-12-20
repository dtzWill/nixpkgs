{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation (rec {
  name = "libedit-20180525-3.1";

  src = fetchurl {
    url = "https://thrysoee.dk/editline/${name}.tar.gz";
    sha256 = "05iicng4kag5hxdc7adbyj1gm3qbmvcc33m9cyx5gys0s67yl6y4";
  };

  outputs = [ "out" "dev" ];

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  # NROFF = "${groff}/bin/nroff";

  patches = [ ./01-cygwin.patch ];

  propagatedBuildInputs = [ ncurses ];

  configureFlags = [ "--enable-widec" ];

  postInstall = ''
    find $out/lib -type f | grep '\.\(la\|pc\)''$' | xargs sed -i \
      -e 's,-lncurses[a-z]*,-L${ncurses.out}/lib -lncursesw,g'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.thrysoee.dk/editline/;
    description = "A port of the NetBSD Editline library (libedit)";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
} // stdenv.lib.optionalAttrs
  (stdenv.hostPlatform.libc == "musl" && stdenv.cc.isClang) /* specific */ {
  # probably just should be #include'ing things where they're not,
  # but made more problematic clang behavior present in LLVM4 through 7.
  # I don't have relevant bugs handy but not up to tracking this down presently.
  NIX_CFLAGS_COMPILE = [ "-include stdc-predef.h" ];
})
