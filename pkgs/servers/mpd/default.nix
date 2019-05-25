{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, systemd, boost, darwin
, libgcrypt, pcre, gtest
, alsaSupport ? true, alsaLib
, avahiSupport ? true, avahi
, dbusSupport ? true, dbus
, upnpSupport ? true, libupnp
, flacSupport ? true, flac
, vorbisSupport ? true, libvorbis
, tremorSupport ? false, tremor # libvorbisidec, can't have both
, madSupport ? true, libmad
, id3tagSupport ? true, libid3tag
, mikmodSupport ? true, libmikmod
, shoutSupport ? true, libshout
, sqliteSupport ? true, sqlite
, curlSupport ? true, curl
, audiofileSupport ? true, audiofile
, bzip2Support ? true, bzip2
, ffmpegSupport ? true, ffmpeg
, fluidsynthSupport ? true, fluidsynth
, zipSupport ? true, zziplib
, samplerateSupport ? true, libsamplerate
, mmsSupport ? true, libmms
, mpg123Support ? true, mpg123
, aacSupport ? true, faad2
, lameSupport ? true, lame
, twolameSupport ? true, twolame
, pulseaudioSupport ? true, libpulseaudio
, jackSupport ? true, libjack2
, gmeSupport ? true, game-music-emu
, icuSupport ? true, icu
, clientSupport ? true, mpd_clientlib
, opusSupport ? true, libopus
, soundcloudSupport ? true, yajl
, nfsSupport ? true, libnfs
, smbSupport ? true, samba
, chromaSupport ? true, chromaprint
, soxrSupport ? true, soxr
, cdioSupport ? true, libcdio
, cdioParanoiaSupport ? true, libcdio-paranoia
, udisks2Support ? true, udisks2
, webdavSupport ? true, expat
, aoSupport ? true, libao
, openALSupport ? true, openal
, mpcSupport ? true, libmpcdec
, sidplaySupport ? true, libsidplayfp
, sndfileSupport ? true, libsndfile
, wavpackSupport ? true, wavpack
, wildmidiSupport ? true, wildmidi
}:

assert avahiSupport -> avahi != null && dbus != null;
assert avahiSupport -> dbusSupport;
assert webdavSupport -> curlSupport;

let
  opt = stdenv.lib.optional;
  mkFlag = c: f: "-D${f}=${if c then "enabled" else "disabled"}";
  major = "0.21";
  minor = "9";

in stdenv.mkDerivation rec {
  name = "mpd-${version}";
  version = "${major}${if minor == "" then "" else "." + minor}";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "MPD";
    rev    = "v${version}";
    sha256 = "1qiigs62pima7pxb6fa7jm0xbgvb7897v89qcl8y2g3gm7sim7g2";
  };

  buildInputs = [ glib boost libgcrypt pcre gtest ]
    ++ opt stdenv.isDarwin darwin.apple_sdk.frameworks.CoreAudioKit
    ++ opt stdenv.isLinux systemd
    ++ opt (stdenv.isLinux && alsaSupport) alsaLib
    ++ opt avahiSupport avahi
    ++ opt avahiSupport dbus
    ++ opt upnpSupport libupnp
    ++ opt flacSupport flac
    ++ opt vorbisSupport libvorbis
    ++ opt tremorSupport tremor
    # using libmad to decode mp3 files on darwin is causing a segfault -- there
    # is probably a solution, but I'm disabling it for now
    ++ opt (!stdenv.isDarwin && madSupport) libmad
    ++ opt id3tagSupport libid3tag
    ++ opt mikmodSupport libmikmod
    ++ opt shoutSupport libshout
    ++ opt sqliteSupport sqlite
    ++ opt curlSupport curl
    ++ opt bzip2Support bzip2
    ++ opt audiofileSupport audiofile
    ++ opt ffmpegSupport ffmpeg
    ++ opt fluidsynthSupport fluidsynth
    ++ opt samplerateSupport libsamplerate
    ++ opt mmsSupport libmms
    ++ opt mpg123Support mpg123
    ++ opt aacSupport faad2
    ++ opt lameSupport lame
    ++ opt twolameSupport twolame
    ++ opt zipSupport zziplib
    ++ opt (!stdenv.isDarwin && pulseaudioSupport) libpulseaudio
    ++ opt (!stdenv.isDarwin && jackSupport) libjack2
    ++ opt gmeSupport game-music-emu
    ++ opt icuSupport icu
    ++ opt clientSupport mpd_clientlib
    ++ opt opusSupport libopus
    ++ opt soundcloudSupport yajl
    ++ opt (!stdenv.isDarwin && nfsSupport) libnfs
    ++ opt (!stdenv.isDarwin && smbSupport) samba
    ++ opt chromaSupport chromaprint
    ++ opt soxrSupport soxr
    ++ opt cdioSupport libcdio
    ++ opt cdioParanoiaSupport libcdio-paranoia
    ++ opt udisks2Support udisks2
    ++ opt webdavSupport expat
    ++ opt aoSupport libao
    ++ opt openALSupport openal
    ++ opt mpcSupport libmpcdec
    ++ opt sidplaySupport libsidplayfp
    ++ opt sndfileSupport libsndfile
    ++ opt wavpackSupport wavpack
    ++ opt wildmidiSupport wildmidi;

  nativeBuildInputs = [ meson ninja pkgconfig ];

  enableParallelBuilding = true;

  mesonFlags =
    [ (mkFlag (!stdenv.isDarwin && alsaSupport) "alsa")
      (mkFlag flacSupport "flac")
      (mkFlag vorbisSupport "vorbis")
      (mkFlag tremorSupport "tremor")
      (mkFlag vorbisSupport "vorbis-encoder")
      (mkFlag (!stdenv.isDarwin && madSupport) "mad")
      (mkFlag mikmodSupport "mikmod")
      (mkFlag id3tagSupport "id3")
      (mkFlag shoutSupport "shout")
      (mkFlag sqliteSupport "sqlite")
      (mkFlag curlSupport "curl")
      (mkFlag audiofileSupport "audiofile")
      (mkFlag bzip2Support "bzip2")
      (mkFlag ffmpegSupport "ffmpeg")
      (mkFlag fluidsynthSupport "fluidsynth")
      (mkFlag zipSupport "zzip")
      (mkFlag samplerateSupport "lsr")
      (mkFlag mmsSupport "mms")
      (mkFlag mpg123Support "mpg123")
      (mkFlag aacSupport "aac")
      (mkFlag lameSupport "lame")
      (mkFlag twolameSupport "twolame")
      (mkFlag (!stdenv.isDarwin && pulseaudioSupport) "pulse")
      (mkFlag (!stdenv.isDarwin && jackSupport) "jack")
      (mkFlag stdenv.isDarwin "osx")
      (mkFlag icuSupport "icu")
      (mkFlag gmeSupport "gme")
      (mkFlag clientSupport "libmpdclient")
      (mkFlag opusSupport "opus")
      (mkFlag soundcloudSupport "soundcloud")
      (mkFlag soundcloudSupport "yajl")
      (mkFlag (!stdenv.isDarwin && nfsSupport) "libnfs")
      (mkFlag (!stdenv.isDarwin && smbSupport) "smbclient")
      (mkFlag chromaSupport "chromaprint")
      (mkFlag dbusSupport "dbus")
      (mkFlag upnpSupport "upnp")
      (mkFlag soxrSupport "soxr")
      (mkFlag cdioSupport "cdio")
      (mkFlag cdioParanoiaSupport "cdio_paranoia")
      (mkFlag udisks2Support "udisks")
      (mkFlag webdavSupport "webdav")
      (mkFlag aoSupport "ao")
      (mkFlag openALSupport "openal")
      (mkFlag mpcSupport "mpcdec")
      (mkFlag sidplaySupport "sidplay")
      (mkFlag sndfileSupport "sndfile")
      (mkFlag wavpackSupport "wavpack")
      (mkFlag wildmidiSupport "wildmidi")
      "-Ddebug=true"
      "-Dtest=true" # tests and debug programs
      "-Dzeroconf=avahi"
      "-Dzlib=enabled"
      "-Dauto_features=enabled"
      # Features we don't have dependencies for yet
      "-Dsndio=disabled" # openBSD?
      "-Dadplug=disabled"
      "-Dmodplug=disabled"
      "-Dshine=disabled"
    ]
    ++ opt stdenv.isLinux
      "-Dsystemd_system_unit_dir=${placeholder "out"}/etc/systemd/system";

  NIX_LDFLAGS = ''
    ${if shoutSupport then "-lshout" else ""}
  '';

  meta = with stdenv.lib; {
    description = "A flexible, powerful daemon for playing music";
    homepage    = http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ astsmtl fuuzetsu ehmry fpletz ];
    platforms   = platforms.unix;

    longDescription = ''
      Music Player Daemon (MPD) is a flexible, powerful daemon for playing
      music. Through plugins and libraries it can play a variety of sound
      files while being controlled by its network protocol.
    '';
  };
}
