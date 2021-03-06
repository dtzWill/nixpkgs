{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  pname = "potrace";
  version = "1.16";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}.tar.gz";
    sha256 = "1k3sxgjqq0jnpk9xxys05q32sl5hbf1lbk1gmfxcrmpdgnhli0my";
  };

  configureFlags = [ "--with-libpotrace" ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://potrace.sourceforge.net/;
    description = "A tool for tracing a bitmap, which means, transforming a bitmap into a smooth, scalable image";
    platforms = platforms.unix;
    maintainers = [ maintainers.pSub ];
    license = licenses.gpl2;
  };
}
