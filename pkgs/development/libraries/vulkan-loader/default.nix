{ stdenv, fetchFromGitHub, cmake, python3, vulkan-headers, pkgconfig
, xlibsWrapper, libxcb, libXrandr, libXext, wayland, addOpenGLRunpath }:

stdenv.mkDerivation rec {
  pname = "vulkan-loader";
  version = "1.2.131.2";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Loader";
    rev = "sdk-${version}";
    sha256 = "12n4mxc6db89258k8i47ql1zna7k94lkwv7lpxg39nm8ypa1ywrv";
  };

  nativeBuildInputs = [ pkgconfig addOpenGLRunpath ];
  buildInputs = [ cmake python3 xlibsWrapper libxcb libXrandr libXext wayland ];
  enableParallelBuilding = true;

  preConfigure = ''
    substituteInPlace loader/vulkan.pc.in --replace 'includedir=''${prefix}/include' 'includedir=${vulkan-headers}/include'
  '';

  cmakeFlags = [
    "-DSYSCONFDIR=${addOpenGLRunpath.driverLink}/share"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  outputs = [ "out" "dev" ];

  # Set RUNPATH so that driver libraries in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addOpenGLRunpath.
  postFixup = ''
    addOpenGLRunpath $out/lib/libvulkan.so
  '';

  meta = with stdenv.lib; {
    description = "LunarG Vulkan loader";
    homepage    = https://www.lunarg.com;
    platforms   = platforms.linux;
    license     = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
