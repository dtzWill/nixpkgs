{ lib, fetchFromGitHub, buildGoModule, go-bindata }:

buildGoModule rec {
  name = "gvisor-containerd-shim-${version}";
  version = "2019-10-09";

  src = fetchFromGitHub {
    owner  = "google";
    repo   = "gvisor-containerd-shim";
    rev    = "f299b553afdd8455a0057862004061ea12e660f5";
    sha256 = "077bhrmjrpcxv1z020yxhx2c4asn66j21gxlpa6hz0av3lfck9lm";
  };

  # XXX: nixpkgs has different hash as they have different default buildGoModule
  modSha256 = "1c8q60kc9y3y2i84j7b9bzj9nl6ai55fdv7vjfmd6s4pnv6aq9b3";

  buildPhase = ''
    make
  '';

  doCheck = true;
  checkPhase = ''
    make test
  '';

  installPhase = ''
    make install DESTDIR="$out"
  '';

  meta = with lib; {
    description = "containerd shim for gVisor";
    homepage    = https://github.com/google/gvisor-containerd-shim;
    license     = licenses.asl20;
    maintainers = with maintainers; [ andrew-d ];
    platforms   = [ "x86_64-linux" ];
  };
}
