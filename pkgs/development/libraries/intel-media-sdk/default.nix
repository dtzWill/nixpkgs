{ stdenv, fetchurl, autoPatchelfHook, cmake, pkgconfig, libdrm, libpciaccess
, libva , libX11, libXau, libXdmcp, libpthreadstubs
}:

stdenv.mkDerivation rec {
  name = "intel-media-sdk-${version}";
  version = "19.3";

  src = fetchurl {
    url = "https://github.com/Intel-Media-SDK/MediaSDK/archive/intel-mediasdk-${version}.tar.gz";
    sha256 = "09p05flby74k7ih04b5khprlc6xvy77765z2wnpijc46dg6id8is";
  };

  # patchelf is needed for binaries in $out/share/samples
  nativeBuildInputs = [ autoPatchelfHook cmake pkgconfig ];
  buildInputs = [
    libdrm libva libpciaccess libX11 libXau libXdmcp libpthreadstubs
  ];

  enableParallelBuild = true;

  meta = with stdenv.lib; {
    description = "Intel Media SDK.";
    license = licenses.mit;
    maintainers = with maintainers; [ midchildan ];
    platforms = with platforms; linux;
  };
}
