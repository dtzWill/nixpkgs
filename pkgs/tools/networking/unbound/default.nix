{ stdenv, fetchurl, openssl, nettle, expat, libevent, dns-root-data }:

stdenv.mkDerivation rec {
  pname = "unbound";
  version = "1.9.3";

  src = fetchurl {
    url = "https://unbound.net/downloads/${pname}-${version}.tar.gz";
    sha256 = "1ykdy62sgzv33ggkmzwx2h0ifm7hyyxyfkb4zckv7gz4f28xsm8v";
  };

  outputs = [ "out" "lib" "man" ]; # "dev" would only split ~20 kB

  buildInputs = [ openssl nettle expat libevent ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-libexpat=${expat.dev}"
    "--with-libevent=${libevent.dev}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--sbindir=${placeholder "out"}/bin"
    "--with-rootkey-file=${dns-root-data}/root.key"
    "--enable-pie"
    "--enable-relro-now"
  ];

  # Fix use of nettle-internal symbols that were renamed in 3.5.1 to force the issue.
  # Use the get methods instead.
  postPatch = ''
    substituteInPlace validator/val_secalgo.c \
      --replace '&nettle_secp_256r1' \
                'nettle_get_secp_256r1()' \
      --replace '&nettle_secp_384r1' \
                'nettle_get_secp_384r1()'
  '';

  installFlags = [ "configfile=${placeholder "out"}/etc/unbound/unbound.conf" ];

  preFixup = stdenv.lib.optionalString (stdenv.isLinux && !stdenv.hostPlatform.isMusl) # XXX: revisit
    # Build libunbound again, but only against nettle instead of openssl.
    # This avoids gnutls.out -> unbound.lib -> openssl.out.
    # There was some problem with this on Darwin; let's not complicate non-Linux.
    ''
      configureFlags="$configureFlags --with-nettle=${nettle.dev} --with-libunbound-only"
      configurePhase
      buildPhase
      installPhase
    ''
    # get rid of runtime dependencies on $dev outputs
  + ''substituteInPlace "$lib/lib/libunbound.la" ''
    + stdenv.lib.concatMapStrings
      (pkg: " --replace '-L${pkg.dev}/lib' '-L${pkg.out}/lib' --replace '-R${pkg.dev}/lib' '-R${pkg.out}/lib'")
      buildInputs;

  meta = with stdenv.lib; {
    description = "Validating, recursive, and caching DNS resolver";
    license = licenses.bsd3;
    homepage = https://www.unbound.net;
    maintainers = with maintainers; [ ehmry fpletz globin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
