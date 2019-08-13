{ stdenv, fetchurl, libogg }:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.3.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0gymm2j3276kr9nz6vmgfwsdfrq6c449n40a0mzz8h6wc7nw7kwi";
  };

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = https://xiph.org/flac/;
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
