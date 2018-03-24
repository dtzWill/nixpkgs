{ stdenv, fetchurl, musl }:

stdenv.mkDerivation rec {
  name = "musl-iconv";
  src = fetchurl {
    name = "iconv.c";
    url = "https://git.alpinelinux.org/cgit/aports/plain/main/musl/iconv.c?id=a3d97e95f766c9c378194ee49361b375f093b26f";
    sha256 = "1mzxnc2ncq8lw9x6n7p00fvfklc9p3wfv28m68j0dfz5l8q2k6pp";
  };

  buildCommand = ''
    mkdir -p $out/{bin,include}
    $CC $src -o $out/bin/iconv
    ln -sv ${stdenv.lib.getDev musl}/include/iconv.h $out/include
  '';
}

