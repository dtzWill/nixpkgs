{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation (rec {
  pname = "libedit";
  version = "20191025-3.1";

  src = fetchurl {
    url = "https://thrysoee.dk/editline/${pname}-${version}.tar.gz";
    sha256 = "0fdznw6fklis39xqk30ihw8dl8kdw9fzq1z42jmbyy6lc1k07zvd";
  };

  outputs = [ "out" "dev" ];

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  # NROFF = "${groff}/bin/nroff";

  patches = [ ./01-cygwin.patch ];

  propagatedBuildInputs = [ ncurses ];

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
