{ stdenv, fetchurl, pkgs, lib }:

stdenv.mkDerivation rec {
  pname    = "hopper";
  version = "4.5.16";
  rev = "v${lib.versions.major version}";

  src = fetchurl {
    url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${rev}-${version}-Linux.pkg.tar.xz";
    sha256 = "0gjnn7f6ibfx46k4bbj8ra7k04s0mrpq7316brgzks6x5yd1m584";
  };

  sourceRoot = ".";

  ldLibraryPath = with pkgs; stdenv.lib.makeLibraryPath  [
libbsd.out libffi.out gmpxx.out python27Full.out python27Packages.libxml2 qt5.qtbase zlib  xlibs.libX11.out xorg_sys_opengl.out xlibs.libXrender.out gcc-unwrapped.lib
  ];

  nativeBuildInputs = [ pkgs.qt5.wrapQtAppsHook ];

  qtWrapperArgs = [ ''--suffix LD_LIBRARY_PATH : ${ldLibraryPath}'' ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share
    cp $sourceRoot/opt/hopper-${rev}/bin/Hopper $out/bin/hopper
    cp -r $sourceRoot/opt/hopper-${rev}/lib $out
    cp -r $sourceRoot/usr/share $out/share
    patchelf \
      --set-interpreter ${stdenv.glibc}/lib/ld-linux-x86-64.so.2 \
      $out/bin/hopper
  '';

  meta = {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.luis ];
    platforms = stdenv.lib.platforms.linux;
  };
}
