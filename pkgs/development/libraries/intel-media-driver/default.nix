{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libva, libpciaccess, intel-gmmlib, libX11
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  version = "20.1.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    rev    = "intel-media-${version}";
    sha256 = "1mww20c9r7a57njqa2835ayjvk46lrv2yks9a2y8i0s5qzdi8m1i";
  };

  cmakeFlags = [
    "-DINSTALL_DRIVER_SYSCONF=OFF"
    "-DLIBVA_DRIVERS_PATH=${placeholder "out"}/lib/dri"
    # Works only on hosts with suitable CPUs.
    "-DMEDIA_RUN_TEST_SUITE=OFF"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ libva libpciaccess intel-gmmlib libX11 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/media-driver;
    license = with licenses; [ bsd3 mit ];
    description = "Intel Media Driver for VAAPI — Broadwell+ iGPUs";
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
