{ stdenv, fetchurl, ocl-icd, opencl-headers }:

let version = "2.2.18.04.06";
in
  stdenv.mkDerivation {
    name = "clinfo";

    src = fetchurl {
      url = "https://github.com/Oblomov/clinfo/archive/${version}.tar.gz";
      sha256 = "f77021a57b3afcdebc73107e2254b95780026a9df9aa4f8db6aff11c03f0ec6c";
    };

    buildInputs = [ ocl-icd opencl-headers ];

    NIX_LDFLAGS = [ "-lOpenCL" ];

    installPhase = ''
      install -Dm755 clinfo $out/bin/clinfo
      install -Dm644 man1/clinfo.1 $out/share/man/man1/clinfo.1
    '';

    meta = with stdenv.lib; {
      description = "Print all known information about all available OpenCL platforms and devices in the system";
      homepage = https://github.com/Oblomov/clinfo;
      license = licenses.cc0;
      platforms = platforms.linux;
      maintainers = with maintainers; [ athas ];
    };
  }
