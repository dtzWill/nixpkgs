{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "cmix";
  version = "18";

  src = fetchzip {
    url = "http://www.byronknoll.com/${pname}-v${version}.zip";
    sha256 = "18749mql263rdzj10jh8v4fy32qhi8rb6npfi6n8pjrr9rdi6w97";
    # https://github.com/NixOS/nixpkgs/issues/38649
    extraPostFetch = ''
      chmod go-w $out
    '';
  };

  makeFlags = [ "CC:=$(CXX)" /* "CC=g++", yes */ ];

  NIX_CFLAGS_COMPILE = [ "-O3" /* override -Ofast, so no compat problems */ ];

  installPhase = ''
    install -Dm755 -t $out/bin/ cmix

    install -Dm644 -t $out/share/cmix/dictionary dictionary/*
  '';

  meta = with stdenv.lib; {
    description = "lossless data compression program aimed at optimizing compression ratio at the cost of high CPU/memory usage";
    homepage = http://www.byronknoll.com/cmix.html;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}


