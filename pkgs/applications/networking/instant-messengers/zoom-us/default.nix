{ stdenv, fetchurl, mkDerivation, autoPatchelfHook
, fetchFromGitHub
# Dynamic libraries
, dbus, glib, libGL, libX11, libXfixes, libuuid, libxcb, qtbase, qtdeclarative
, qtimageformats, qtlocation, qtquickcontrols, qtquickcontrols2, qtscript, qtsvg
, qttools, qtwayland, qtwebchannel, qtwebengine
# Runtime
, coreutils, libjpeg_turbo, pciutils, procps, utillinux, libv4l
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  inherit (stdenv.lib) concatStringsSep makeBinPath optional;

  version = "3.5.330166.1202";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "1fjirl4hmxvy4kp3b0n97mn8sz355ik10297qx6hcr0fhn2v0nig";
    };
  };

  # Used for icons, appdata, and desktop file.
  desktopIntegration = fetchFromGitHub {
    owner = "flathub";
    repo = "us.zoom.Zoom";
    rev = "0d294e1fdd2a4ef4e05d414bc680511f24d835d7";
    sha256 = "0rm188844a10v8d6zgl2pnwsliwknawj09b02iabrvjw5w1lp6wl";
  };

in mkDerivation {
  pname = "zoom-us";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    dbus glib libGL libX11 libXfixes libuuid libxcb libjpeg_turbo
    qtbase qtdeclarative qtlocation qtquickcontrols qtquickcontrols2 qtscript
    qtwebchannel qtwebengine qtimageformats qtsvg qttools qtwayland
  ];

  runtimeDependencies = optional pulseaudioSupport libpulseaudio;

  installPhase =
    let
      files = concatStringsSep " " [
        "*.pcm"
        "*.png"
        "ZoomLauncher"
        "config-dump.sh"
        "timezones"
        "translations"
        "version.txt"
        "zcacert.pem"
        "zoom"
        "zoom.sh"
        "zoomlinux"
        "zopen"
      ];
    in ''
      runHook preInstall

      mkdir -p $out/{bin,share/zoom-us}

      cp -ar ${files} $out/share/zoom-us

      # TODO Patch this somehow; tries to dlopen './libturbojpeg.so' from cwd
      ln -s $(readlink -e "${libjpeg_turbo.out}/lib/libturbojpeg.so") $out/share/zoom-us/libturbojpeg.so

      runHook postInstall
    '';

  postInstall = ''
    mkdir -p $out/share/{applications,appdata,icons}

    # Desktop File
    cp ${desktopIntegration}/us.zoom.Zoom.desktop $out/share/applications
    substituteInPlace $out/share/applications/us.zoom.Zoom.desktop \
        --replace "Exec=zoom" "Exec=$out/bin/zoom-us"

    # Appdata
    cp ${desktopIntegration}/us.zoom.Zoom.appdata.xml $out/share/appdata

    # Icons
    for icon_size in 64 96 128 256; do
        path=$icon_size'x'$icon_size
        icon=${desktopIntegration}/us.zoom.Zoom.$icon_size.png

        mkdir -p $out/share/icons/hicolor/$path/apps
        cp $icon $out/share/icons/hicolor/$path/apps/us.zoom.Zoom.png
    done

    ln -s $out/share/zoom-us/zoom $out/bin/zoom-us
  '';

  qtWrapperArgs = [
    ''--prefix PATH : ${makeBinPath [ coreutils glib.dev pciutils procps qttools.dev utillinux ]}''
    #''--prefix LD_PRELOAD : ${libv4l}/lib/libv4l/v4l2convert.so''
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = https://zoom.us/;
    description = "zoom.us video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with stdenv.lib.maintainers; [ danbst tadfisher ];
  };

}
