{ lib, fetchFromGitHub, python3Packages, makeWrapper, sox, flac, faac, lame
, ffmpeg, vorbis-tools, nodejs, pulseaudio, alsaLib, alsaUtils, youtube-dl
, opusTools, gstreamer, libnotify, glib, dbus-glib, gobject-introspection, wrapGAppsHook
, alsaSupport ? false
, systemTray ? true
, ffmpegSupport ? true
, youtubeSupport ? true
}:

# We define non-python packages here so we can reuse the binding in
# makeSearchPathOutput below.
let packages = [
  vorbis-tools
  sox
  flac
  faac
  lame
  opusTools
  gstreamer
  libnotify
  glib
  dbus-glib
  gobject-introspection
] ++ lib.optional alsaSupport [ alsaLib ffmpeg ]
  ++ lib.optional (!alsaSupport) pulseaudio
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional youtubeSupport youtube-dl;

in python3Packages.buildPythonApplication rec {
  pname = "mkchromecast";
  version = "0.3.8.1-git";

  src = fetchFromGitHub rec {
    owner = "muammar";
    repo = pname;
    #rev = version;
    rev = "417876bd77926c941e46bf45be9bbeef6350e69c";
    sha256 = "1392l17493y1gg0msk1vkfqcqpffhjjmvcxfsad77k2l0al9n5r6";
  };

  propagatedBuildInputs = with python3Packages; [
    PyChromecast
    psutil
    mutagen
    flask
    netifaces
    requests
    pygobject3
    dbus-python
  ] ++ lib.optional systemTray pyqt5 ++ packages;

  # Relies on an old version (0.7.7) of PyChromecast unavailable in Nixpkgs.
  doCheck = false;

  # Patch a relative path referring to a Javascript file, to be absolute.
  patchPhase = ''
    sed -i "s_\['\./nodejs_['${placeholder "out"}/share/mkchromecast/nodejs_" mkchromecast/video.py

    sed -i 's,/usr/share/mkchromecast,${placeholder "out"}/share/mkchromecast,g' \
      mkchromecast/{video,systray}.py
  '';

  buildInputs = [ wrapGAppsHook ];

  makeWrapperArgs = [
      ''--prefix PYTHONPATH : "$out/lib:$PYTHONPATH"''
      ''--prefix PATH : "${lib.makeSearchPathOutput "" "bin" packages}"''
  ];

  postInstall = ''
    wrapProgram "$out/bin/mkchromecast"
  '';

  meta = with lib; {
    homepage = https://github.com/muammar/mkchromecast;
    description = "Cast macOS and Linux Audio/Video to your Google Cast and Sonos Devices";
    license = licenses.mit;
    maintainers = with maintainers; [ shou ];
  };
}
