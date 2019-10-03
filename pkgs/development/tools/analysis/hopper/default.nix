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

  # TODO: cleanup/modernize/simplify (and get deps as args not from pkgs)
  ldLibraryPath = with pkgs; stdenv.lib.makeLibraryPath  [
libbsd.out libffi.out gmpxx.out python27Full.out python27Packages.libxml2 qt5.qtbase zlib  xlibs.libX11.out xorg_sys_opengl.out xlibs.libXrender.out gcc-unwrapped.lib
  ];

  nativeBuildInputs = [ pkgs.qt5.wrapQtAppsHook ];

  qtWrapperArgs = [ ''--suffix LD_LIBRARY_PATH : ${ldLibraryPath}'' ];

  installPhase = ''
    mkdir -p $out/{bin,lib,share}
    cp $sourceRoot/opt/hopper-${rev}/bin/Hopper $out/bin/hopper
    cp -r -t $out \
      $sourceRoot/opt/hopper-${rev}/lib \
      $sourceRoot/usr/share

    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      $out/bin/hopper

    substituteInPlace $out/share/applications/hopper-${rev}.desktop \
      --replace /opt/hopper-${rev}/bin/Hopper $out/bin/hopper
  '';

  meta = {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.luis ];
    platforms = stdenv.lib.platforms.linux;
  };
}
