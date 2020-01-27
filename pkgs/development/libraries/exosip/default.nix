{ stdenv, fetchurl, libosip, openssl, pkgconfig }:

stdenv.mkDerivation rec {
 pname = "libexosip2";
 version = "5.1.1";

 src = fetchurl {
    url = "mirror://savannah/exosip/${pname}-${version}.tar.gz";
    sha256 = "1qkj28kmx15sklw0q0visgqyddqjxjz6c5qn6vzra24fpw00qhi1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libosip openssl ];

  meta = with stdenv.lib; {
    license = licenses.gpl2Plus;
    description = "Library that hides the complexity of using the SIP protocol";
    platforms = platforms.linux;
  };
}
