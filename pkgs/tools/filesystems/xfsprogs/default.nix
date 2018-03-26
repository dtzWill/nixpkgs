{ stdenv, fetchpatch, fetchgit, autoconf, automake, gettext, libtool, readline, utillinux, libunistring, pkgconfig }:

let
  gentooPatch = name: sha256: fetchpatch {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/xfsprogs/files/${name}?id=2517dd766cf84d251631f4324f7ec4bce912abb9";
    inherit sha256;
  };
in

stdenv.mkDerivation rec {
  name = "xfsprogs-${version}";
  version = "4.15.1";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git";
    rev = "refs/tags/v${version}";
    sha256 = "0s5hisnb2qww1lljyfjvwgqld0a9g3g18bgbvdcgyn80sx5l66l4";
  };

  outputs = [ "bin" "dev" "out" "doc" ];

  nativeBuildInputs = [ autoconf automake libtool gettext pkgconfig ];
  propagatedBuildInputs = [ utillinux ]; # Dev headers include <uuid/uuid.h>
  buildInputs = [ readline libunistring ];

  enableParallelBuilding = true;

  # Why is all this garbage needed? Why? Why?
  patches = [
    (gentooPatch "xfsprogs-4.9.0-underlinking.patch" "1r7l8jphspy14i43zbfnjrnyrdm4cpgyfchblascxylmans0gci7")
    (gentooPatch "xfsprogs-4.15.0-sharedlibs.patch" "0bv2naxpiw7vcsg8p1v2i47wgfda91z1xy1kfwydbp4wmb4nbyyv")
    (gentooPatch "xfsprogs-4.15.0-docdir.patch" "1srgdidvq2ka0rmfdwpqp92fapgh53w1h7rajm4nnby5vp2v8dfr")
    #./glibc-2.27.patch
  ];

  preConfigure = ''
    sed -i Makefile -e '/cp include.install-sh/d'
    make configure
  '';

  configureFlags = [
    "--disable-lib64"
    "--enable-readline"
  ];

  installFlags = [ "install-dev" ];

  # FIXME: forbidden rpath
  postInstall = ''
    find . -type d -name .libs | xargs rm -rf
  '';

  meta = with stdenv.lib; {
    homepage = http://xfs.org/;
    description = "SGI XFS utilities";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dezgeg ];
  };
}
