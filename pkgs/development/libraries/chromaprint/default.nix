{ stdenv, fetchurl, cmake, boost, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "chromaprint";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/acoustid/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    sha256 = "10kz8lncal4s2rp2rqpgc6xyjp0jzcrihgkx7chf127vfs5n067a";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ffmpeg ];

  cmakeFlags = [ "-DBUILD_EXAMPLES=ON" ];

  meta = with stdenv.lib; {
    homepage = https://acoustid.org/chromaprint;
    description = "AcoustID audio fingerprinting library";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
