{stdenv, fetchFromGitHub, autoreconfHook, ruby, opencl-headers, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "ocl-icd";
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "OCL-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "075pj99nanl75hyv93wys9ba3x7lhcdj0awdcd8bss6mdxqxj5mc";
  };

  nativeBuildInputs = [ autoreconfHook ruby addOpenGLRunpath ];

  buildInputs = [ opencl-headers ];

  postPatch = ''
    sed -i 's,"/etc/OpenCL/vendors","${addOpenGLRunpath.driverLink}/etc/OpenCL/vendors",g' ocl_icd_loader.c
  '';

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    addOpenGLRunpath $out/lib/libOpenCL.so
  '';

  meta = with stdenv.lib; {
    description = "OpenCL ICD Loader for ${opencl-headers.name}";
    homepage    = https://github.com/OCL-dev/ocl-icd;
    license     = licenses.bsd2;
    platforms = platforms.linux;
  };
}
