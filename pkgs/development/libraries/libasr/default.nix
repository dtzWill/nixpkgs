{ stdenv, fetchurl, libevent, openssl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libasr";
  version=  "1.0.3";

  src = fetchurl {
    url = "https://www.opensmtpd.org/archives/${pname}-${version}.tar.gz";
    sha256 = "13fn4sr4vlcx1xijpl26nmnxawyls4lr5q3mi11jdm76f80qxn4w";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libevent openssl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSMTPD/libasr;
    description = "Free, simple and portable asynchronous resolver library";
    license = licenses.isc;
    maintainers = [ maintainers.koral ];
    platforms = platforms.unix;
  };
}
