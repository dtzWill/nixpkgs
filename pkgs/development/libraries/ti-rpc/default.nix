{ fetchurl, stdenv, autoreconfHook, libkrb5, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libtirpc";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1jl6a5kkw2vrp4gb6pmvf72rqimywvwfb9f7iz2xjg4wgq63bdpk";
  };

  outputs = [ "out" "dev" ];

  KRB5_CONFIG = "${libkrb5.dev}/bin/krb5-config";
  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libkrb5 ];

  preConfigure = ''
    sed -es"|/etc/netconfig|$out/etc/netconfig|g" -i doc/Makefile.in tirpc/netconfig.h
  '';

  patches = [
    (fetchpatch {
      name = "dont-use-internal-bits-endian-header-use-endian.patch";
      url = "https://git.linux-nfs.org/?p=steved/libtirpc.git;a=patch;h=d04f4d6f0e682f16b0ce96839ab4eadade591eb1";
      sha256 = "1paf1c3bgmc07ci85wv025kfl56v9agxg00pk7z4mzpf59dk526h";
    })
  ];

  preInstall = "mkdir -p $out/etc";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/libtirpc/;
    description = "The transport-independent Sun RPC implementation (TI-RPC)";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    longDescription = ''
       Currently, NFS commands use the SunRPC routines provided by the
       glibc.  These routines do not support IPv6 addresses.  Ulrich
       Drepper, who is the maintainer of the glibc, refuses any change in
       the glibc concerning the RPC.  He wants the RPC to become a separate
       library.  Other OS (NetBSD, FreeBSD, Solarix, HP-UX, AIX) have
       migrated their SunRPC library to a TI-RPC (Transport Independent
       RPC) implementation.  This implementation allows the support of
       other transports than UDP and TCP over IPv4.  FreeBSD provides a
       TI-RPC library ported from NetBSD with improvements.  This library
       already supports IPv6.  So, the FreeBSD release 5.2.1 TI-RPC has
       been ported to replace the SunRPC of the glibc.
    '';
  };
}
