# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{ mkDerivation, lib, fetchurl, alsaLib, bzip2, fftw, libjack2, libX11, liblo
, libmad, liboggz, libfishsound, librdf, librdf_raptor, librdf_rasqal
, libsamplerate , libsndfile, pkgconfig, libpulseaudio, qtbase, qtsvg, redland
, qmake, rubberband, serd, sord, vampSDK, fftwFloat, capnproto, libid3tag
, libopus, opusfile
}:

mkDerivation rec {
  pname = "sonic-visualiser";
  version = "4.0";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2580/sonic-visualiser-${version}.tar.gz";
    sha256 = "0r9rnkqcv2x8cr93g0a94gw1y9xh4mpcjll302yzsdxqwwjy2pim";
  };

  buildInputs =
    [ libsndfile qtbase qtsvg fftw fftwFloat bzip2 librdf rubberband
      libsamplerate vampSDK alsaLib librdf_raptor librdf_rasqal redland
      serd
      sord
      # optional
      libjack2
      # portaudio
      libpulseaudio
      libmad
      liboggz
      libfishsound
      liblo
      libX11
      capnproto
      libid3tag
      libopus
      opusfile
    ];

  nativeBuildInputs = [ pkgconfig qmake ];

  dontUseQmakeConfigure = true;

  enableParallelBuilding = true;

  preBuild = ''
    # not separate check, idk
    export HOME=$TMPDIR
  '';

  postInstall = ''
    chmod +x $out/bin/{piper-vamp-simple-server,vamp-plugin-load-checker}
  '';

  meta = with lib; {
    description = "View and analyse contents of music audio files";
    homepage = http://www.sonicvisualiser.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
