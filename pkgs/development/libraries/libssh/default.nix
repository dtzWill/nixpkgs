{ stdenv, fetchurl, pkgconfig, cmake, zlib, openssl, libsodium }:

stdenv.mkDerivation rec {
  pname = "libssh";
  version = "0.9.3";

  src = fetchurl {
    url = "https://www.libssh.org/files/0.9/${pname}-${version}.tar.xz";
    sha256 = "034gd0rphrfgcf8n7568pns20b2nlspz65lzc8yqpmff9n4mz2rc";
  };

  postPatch = ''
    # Fix headers to use libsodium instead of NaCl
    sed -i 's,nacl/,sodium/,g' ./include/libssh/curve25519.h src/curve25519.c
  '';

  # single output, otherwise cmake and .pc files point to the wrong directory
  # outputs = [ "out" "dev" ];

  buildInputs = [ zlib openssl libsodium ];

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    description = "SSH client library";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ sander ];
    platforms = platforms.all;
  };
}
