{ stdenv, fetchFromGitHub
, autoreconfHook, pkgconfig
, libqb, libxml2, libnl, lksctp-tools
, nss, openssl, bzip2, lzo, lz4, xz, zlib
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "kronosnet";
  version = "1.11";
  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0xk25mdli6znx9dwp79f62ahvhi1g79ndzc3p1ld0a10m43vm76z";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig doxygen ];

  buildInputs = [
    libqb libxml2 libnl lksctp-tools
    nss openssl
    bzip2 lzo lz4 xz zlib
  ];

  meta = with stdenv.lib; {
    description = "VPN on steroids";
    homepage = https://kronosnet.org/;
    license = [ licenses.lgpl21Plus licenses.gpl2Plus ];
  };
}
