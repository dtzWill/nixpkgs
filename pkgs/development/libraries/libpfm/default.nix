{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  version = "unstable-2019-08-08";
  name = "libpfm";

  src = fetchgit {
    url = "https://git.code.sf.net/p/perfmon2/libpfm4";
    rev = "815ff28a0b2a3bebf3fc1bf744d71af303d474d6";
    sha256 = "1mgylpxqbg49w84hm1wcf7zs24xiy3dlz996ixlgm521gnlg9317";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=true"
    "ARCH=${stdenv.hostPlatform.uname.processor}"
    "SYS=${stdenv.hostPlatform.uname.system}"
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  outputs = [ "out" "examples" ];

  installTargets = [ "install" "install_examples" ];

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $examples/bin
    find $out/share/doc/*/{perf_,}examples -executable -type f -print0 | xargs -0 -r mv -vt $examples/bin
    find $out/share/doc -type d -empty -print -delete
  '';

  meta = with stdenv.lib; {
    description = "Helper library to program the performance monitoring events";
    longDescription = ''
      This package provides a library, called libpfm4 which is used to
      develop monitoring tools exploiting the performance monitoring
      events such as those provided by the Performance Monitoring Unit
      (PMU) of modern processors.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.pierron ];
    platforms = platforms.linux;
  };
}
