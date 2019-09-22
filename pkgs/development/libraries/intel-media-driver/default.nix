{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libva, libpciaccess, intel-gmmlib, libX11
}:

stdenv.mkDerivation rec {
  name = "intel-media-driver-${version}";
  # version = "19.3.pre4";
  version = "git-20190919";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    # rev    = "intel-media-${version}";
    rev = "cf80fa0e3c81361696ada1285ea17a417114be47";
    sha256 = "1ydmncgfz0w9iwfsz3dss78cc35wdhgy5kdvgwb72ybc3c951cx2";
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
