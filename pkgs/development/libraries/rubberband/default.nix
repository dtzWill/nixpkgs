{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vampSDK, ladspaH }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "1.8.2";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "1jn3ys16g4rz8j3yyj5np589lly0zhs3dr9asd0l9dhmf5mx1gl6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsamplerate libsndfile fftw vampSDK ladspaH ];

  meta = with stdenv.lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = https://www.breakfastquay.com/rubberband/index.html;
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
