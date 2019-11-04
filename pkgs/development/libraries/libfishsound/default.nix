{ stdenv, fetchurl, pkgconfig, libvorbis, speex, flac, liboggz, libsndfile }:

stdenv.mkDerivation rec {
  pname = "libfishsound";
  version = "1.0.0";
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1iz7mn6hw2wg8ljaw74f4g2zdj68ib88x4vjxxg3gjgc5z75f2rf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libvorbis speex flac liboggz libsndfile ];

  # TODO: meta
}
