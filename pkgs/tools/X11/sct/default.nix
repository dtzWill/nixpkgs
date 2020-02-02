{ stdenv, fetchurl, libX11, libXrandr }:

stdenv.mkDerivation rec {
  name = "sct";
  version = "0.5";

  src = fetchurl {
    url = "https://www.umaxx.net/dl/sct-${version}.tar.gz";
    sha256 = "0lrhx771iccbw04wrhj0ygids1pzmjfc4hvklm30m3p3flvhqf0m";
  };

  buildInputs = [ libX11 libXrandr ];

  makeFlags = [
    "CC=cc"
    "PREFIX=${placeholder "out"}"
  ];

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    homepage = https://www.tedunangst.com/flak/post/sct-set-color-temperature;
    description = "A minimal utility to set display colour temperature";
    maintainers = [ maintainers.raskin ];
    license = licenses.publicDomain;
    platforms = with platforms; linux ++ freebsd ++ openbsd;
  };
}
