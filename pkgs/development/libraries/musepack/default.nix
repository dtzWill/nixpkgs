{ stdenv, fetchurl, cmake
, libcue
}:

stdenv.mkDerivation rec {
  pname = "musepack";
  version = "475";

  src = fetchurl {
    url = "https://files.musepack.net/source/${pname}_src_r${version}.tar.gz";
    sha256 = "0avv88fgiqzjrkwmydkh9dvbli88qal5dma2c42y30vzk4pp9cd4";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Musepack SV8 libs & tools";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
