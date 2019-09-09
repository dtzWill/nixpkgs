{
  mkDerivation, lib, fetchurl,
  gettext, pkgconfig,
  qtbase,
  alsaLib, curl, faad2, ffmpeg, flac, fluidsynth, gdk-pixbuf, lame, libbs2b,
  libcddb, libcdio, libcue, libjack2, libmad, libmms, libmodplug,
  libmowgli, libnotify, libogg, libpulseaudio, libsamplerate, libsidplayfp,
  libsndfile, libvorbis, libxml2, lirc, mpg123, neon, qtmultimedia, soxr,
  wavpack,
  SDL, ncurses
}:

let
  version = "3.10.1";
  sources = {
    "audacious-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
      sha256 = "14vbkhld5hwh96j8p8hjq9ybvc2m060a1y8crz14i51wpd0fhrl3";
    };

    "audacious-plugins-${version}" = fetchurl {
      url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
      sha256 = "0hi61825ayrwc4snwr76f2669k06fii3n8ll1szjk5zr65v1ghzf";
    };
  };
in

mkDerivation {
  inherit version;
  pname = "audacious-qt5";

  sourceFiles = lib.attrValues sources;
  sourceRoots = lib.attrNames sources;

  nativeBuildInputs = [ gettext pkgconfig ];

  buildInputs = [
    # Core dependencies
    qtbase

    # Plugin dependencies
    alsaLib curl faad2 ffmpeg flac fluidsynth gdk-pixbuf lame libbs2b libcddb
    libcdio libcue libjack2 libmad libmms libmodplug libmowgli
    libnotify libogg libpulseaudio libsamplerate libsidplayfp libsndfile
    libvorbis libxml2 lirc mpg123 neon qtmultimedia soxr wavpack
    SDL ncurses
  ];

  configureFlags = [ "--enable-qt" "--disable-gtk" ];

  # Here we build both audacious and audacious-plugins in one
  # derivations, since they really expect to be in the same prefix.
  # This is slighly tricky.
  builder = builtins.toFile "builder.sh" ''
    sourceFiles=( $sourceFiles )
    sourceRoots=( $sourceRoots )
    for (( i=0 ; i < ''${#sourceFiles[*]} ; i++ )); do

      (
        src=''${sourceFiles[$i]}
        sourceRoot=''${sourceRoots[$i]}
        source $stdenv/setup
        genericBuild
      )

      if [ $i == 0 ]; then
        nativeBuildInputs="$out $nativeBuildInputs"
      fi

    done
  '';

  meta = with lib; {
    description = "Audio player";
    homepage = https://audacious-media-player.org/;
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; linux;
    license = with licenses; [
      bsd2 bsd3 #https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2 gpl3 lgpl2Plus #http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
