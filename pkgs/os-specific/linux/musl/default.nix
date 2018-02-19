{ stdenv, lib, fetchurl, fetchzip
, buildPackages
, linuxHeaders ? null
, useBSDCompatHeaders ? true
}:
let
  cdefs_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-cdefs.h";
    sha256 = "16l3dqnfq0f20rzbkhc38v74nqcsh9n3f343bpczqq8b1rz6vfrh";
  };
  queue_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-queue.h";
    sha256 = "12qm82id7zys92a1qh2l1qf2wqgq6jr4qlbjmqyfffz3s3nhfd61";
  };
  tree_h = fetchurl {
    url = "http://git.alpinelinux.org/cgit/aports/plain/main/libc-dev/sys-tree.h";
    sha256 = "14igk6k00bnpfw660qhswagyhvr0gfqg4q55dxvaaq7ikfkrir71";
  };

in
stdenv.mkDerivation rec {
  name    = "musl-${version}";
  version = "2018-02-12";

  src = fetchurl {
    # XXX: I rehosted this since cgit snapshots are not stable
    #  https://git.musl-libc.org/cgit/musl/snapshot/musl-75cba9c67fde03421b96c1bcbaf666b4b348739d.tar.gz
    url = https://wdtz.org/files/musl-75cba9c67fde03421b96c1bcbaf666b4b348739d.tar.gz;
    sha256 = "0idssnfy32jfjfirdqsz541knd1k8ppcr43mbsfna1clb8fcdqvn";
  };
  #src = fetchurl {
  #  url    = "http://www.musl-libc.org/releases/musl-${version}.tar.gz";
  #  sha256 = "0651lnj5spckqjf83nz116s8qhhydgqdy3rkl4icbh5f05fyw5yh";
  #};

  enableParallelBuilding = true;

  # Disable auto-adding stack protector flags,
  # so musl can selectively disable as needed
  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    configureFlagsArray+=("--syslibdir=$out/lib")
  '';

  configureFlags = [
    "--enable-shared"
    "--enable-static"
    "CFLAGS=-fstack-protector-strong"
    # Fix cycle between outputs
    "--disable-wrapper"
  ];

  outputs = [ "out" "dev" ];

  dontDisableStatic = true;
  dontStrip = true;

  postInstall =
  ''
    # Not sure why, but link in all but scsi directory as that's what uclibc/glibc do.
    # Apparently glibc provides scsi itself?
    (cd $dev/include && ln -s $(ls -d ${linuxHeaders}/include/* | grep -v "scsi$") .)
  '' +
  ''
    mkdir -p $out/bin
    # Create 'ldd' symlink, builtin
    ln -s $out/lib/libc.so $out/bin/ldd
  '' + lib.optionalString useBSDCompatHeaders ''
    install -D ${queue_h} $dev/include/sys/queue.h
    install -D ${cdefs_h} $dev/include/sys/cdefs.h
    install -D ${tree_h} $dev/include/sys/tree.h
  '';

  passthru.linuxHeaders = linuxHeaders;

  meta = {
    description = "An efficient, small, quality libc implementation";
    homepage    = "http://www.musl-libc.org";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
