{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "nv-codec-headers";
  version = "9.1.23.0";

  src = fetchgit {
    url = "https://git.videolan.org/git/ffmpeg/nv-codec-headers.git";
    rev = "n${version}";
    sha256 = "029xjmsbvg4zfrzgfv7kwaipvk1g54h044ll07gpcdc23b67l0zm";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "FFmpeg version of headers for NVENC";
    homepage = "https://ffmpeg.org/";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.MP2E ];
    platforms = stdenv.lib.platforms.all;
  };
}
