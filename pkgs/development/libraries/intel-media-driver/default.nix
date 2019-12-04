{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libva, libpciaccess, intel-gmmlib, libX11
}:

stdenv.mkDerivation rec {
  pname = "intel-media-driver";
  #version = "19.4.pre2";
  version = "git-20191127";
  #version = "git-20190919";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "media-driver";
    #rev    = "intel-media-${version}";
    #rev = "cf80fa0e3c81361696ada1285ea17a417114be47";
    rev = "fe586caa2aa85f4869eb97a70c8a489bba9a00a5";
    sha256 = "1z5rsfcfmc8bmqbr5nhld2rp07hbykgr6mpmb23gibd6xi2f0z1k";
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
