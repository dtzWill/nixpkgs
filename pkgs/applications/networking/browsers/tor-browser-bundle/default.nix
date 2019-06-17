{ stdenv
, fetchgit
, fetchurl
, symlinkJoin
, makeDesktopItem

# Common run-time dependencies
, zlib

# libxul run-time dependencies
, atk
, cairo
, dbus
, dbus-glib
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gtk3
, libxcb
, libX11
, libXext
, libXrender
, libXt
, pango

, tor
, tor-browser-unwrapped

# Audio support
, audioSupport ? mediaSupport
, pulseaudioSupport ? false
, libpulseaudio
, apulse

# Media support (implies audio support)
, mediaSupport ? false
, ffmpeg

# Extensions, common
, zip

# Wrapper runtime
, coreutils
#, glibcLocales
, gnome3
, runtimeShell
, shared-mime-info
, gsettings-desktop-schemas

# Fonts
, noto-fonts
, noto-fonts-emoji
, stix-two

# HTTPS Everywhere
, git
, libxml2 # xmllint
, libxslt
, python36
, rsync
, which
, xxd
, utillinux # getopt
, openssl

# Pluggable transports
, obfs4

# Customization
, extraPrefs ? ""
, extraExtensions ? [ ]
}:

with stdenv.lib;

let
  libPath = makeLibraryPath libPkgs;

  libPkgs = [
    atk
    cairo
    dbus
    dbus-glib
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gtk3
    libxcb
    libX11
    libXext
    libXrender
    libXt
    pango
    stdenv.cc.cc
    stdenv.cc.libc
    zlib
  ]
  ++ optionals pulseaudioSupport [ libpulseaudio ]
  ++ optionals mediaSupport [
    ffmpeg
  ];

  # XXX: latest tor-browser-build
  # may not work with earlier versions?
  inherit (tor-browser-unwrapped) version;

  lang = "en-US";


  tor-browser-build_src = fetchgit {
    url = "https://git.torproject.org/builders/tor-browser-build.git";
    rev = "refs/tags/tbb-${version}";
    sha256 = "0s3f3ghdi5hhp7vpm4kaxjmf9vd0hmdrkc3szgw22if9g3nx2ga9";
  };

  firefoxExtensions = import ./extensions.nix {
    inherit stdenv fetchurl fetchgit zip
      git libxml2 libxslt python36 rsync
      which xxd utillinux openssl;
  };

  bundledExtensions = with firefoxExtensions; [
    https-everywhere
    noscript
    torbutton
    tor-launcher
  ] ++ extraExtensions;

  fontsEnv = symlinkJoin {
    name = "tor-browser-fonts";
    paths = [ noto-fonts noto-fonts-emoji stix-two ];
  };

  fontsDir = "${fontsEnv}/share/fonts";
in
stdenv.mkDerivation rec {
  pname = "tor-browser-bundle";
  inherit version;

  preferLocalBuild = true;
  allowSubstitutes = false;

  desktopItem = makeDesktopItem {
    name = "torbrowser";
    exec = "tor-browser";
    icon = "torbrowser";
    desktopName = "Tor Browser";
    genericName = "Web Browser";
    comment = meta.description;
    categories = "Network;WebBrowser;Security;";
  };
  buildInputs = [ tor-browser-unwrapped tor ];

  # The following creates a customized firefox distribution.  For
  # simplicity, we copy the entire base firefox runtime, to work around
  # firefox's annoying insistence on resolving the installation directory
  # relative to the real firefox executable.  A little tacky and
  # inefficient but it works.
  buildCommand = ''
    TBBUILD=${tor-browser-build_src}/projects/tor-browser
    TBDATA_PATH=TorBrowser-Data
    # The final libPath.  Note, we could split this into firefoxLibPath
    # and torLibPath for accuracy, but this is more convenient ...
    ## libPath=${libPath}:$TBB_IN_STORE:$TBB_IN_STORE/TorBrowser/Tor

    # apulse uses a non-standard library path.  For now special-case it.
    ${optionalString (audioSupport && !pulseaudioSupport) ''
      libPath=${apulse}/lib/apulse:$libPath
    ''}

    self=$out/lib/tor-browser
    mkdir -p $self && cd $self

    TBDATA_IN_STORE=$self/$TBDATA_PATH

    # Copy bundle data
    cp -dR ${tor-browser-unwrapped}/lib"/"*"/"* .
    chmod -R +w .

    # Generate preferences
    bundlePlatform=linux
    bundleData=$TBBUILD/Bundle-Data
    mkdir -p $TBDATA_PATH
    mkdir -p browser/defaults/preferences
    cat \
      $bundleData/PTConfigs/$bundlePlatform/torrc-defaults-appendix \
      $bundleData/$bundlePlatform/Data/Tor/torrc-defaults \
      >> $TBDATA_PATH/torrc-defaults
    cat \
      $bundleData/PTConfigs/bridge_prefs.js \
      | grep -v "default_bridge\.snowflake" \
      >> browser/defaults/preferences/00-prefs.js

    # Prepare for autoconfig.
    #
    # See https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
    cat >defaults/pref/autoconfig.js <<EOF
    //
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    EOF

    # Hard-coded Firefox preferences.
    cat >mozilla.cfg <<EOF
    // First line must be a comment

    // Always update via Nixpkgs
    lockPref("app.update.auto", false);
    lockPref("app.update.enabled", false);
    lockPref("extensions.update.autoUpdateDefault", false);
    lockPref("extensions.update.enabled", false);
    lockPref("extensions.torbutton.updateNeeded", false);
    lockPref("extensions.torbutton.versioncheck_enabled", false);

    // User should never change these.  Locking prevents these
    // values from being written to prefs.js, avoiding Store
    // path capture.
    lockPref("extensions.torlauncher.torrc-defaults_path", "$TBDATA_IN_STORE/torrc-defaults");
    lockPref("extensions.torlauncher.tor_path", "${tor}/bin/tor");

    // Reset pref that captures store paths.
    clearPref("extensions.xpiState");
    clearPref("extensions.bootstrappedAddons");

    // Stop obnoxious first-run redirection.
    lockPref("noscript.firstRunRedirection", false);

    // Insist on using IPC for communicating with Tor
    //
    // Defaults to creating \$TBB_HOME/TorBrowser/Data/Tor/{socks,control}.socket
    lockPref("extensions.torlauncher.control_port_use_ipc", true);
    lockPref("extensions.torlauncher.socks_port_use_ipc", true);

    // Allow sandbox access to sound devices if using ALSA directly
    ${if (audioSupport && !pulseaudioSupport) then ''
      pref("security.sandbox.content.write_path_whitelist", "/dev/snd/");
    '' else ''
      clearPref("security.sandbox.content.write_path_whitelist");
    ''}

    // User customization
    ${optionalString (extraPrefs != "") ''
      ${extraPrefs}
    ''}
    EOF

    # Hard-code path to TBB fonts; xref: FONTCONFIG_FILE in the wrapper below
    sed $bundleData/$bundlePlatform/Data/fontconfig/fonts.conf \
        -e "s,<dir>fonts</dir>,\0<dir>${fontsDir}</dir>," \
        > $TBDATA_PATH/fonts.conf

    # Preload extensions
    find ${toString bundledExtensions} -name '*.xpi' -exec ln -s -t browser/extensions '{}' '+'

    # Hard-code paths to geoip data files.  TBB resolves the geoip files
    # relative to torrc-defaults_path but if we do not hard-code them
    # here, these paths end up being written to the torrc in the user's
    # state dir.
    ln -s -t $TBDATA_PATH ${tor.geoip}/share/tor/geoip{,6}
    cat >>$TBDATA_PATH/torrc-defaults <<EOF
    GeoIPFile $TBDATA_IN_STORE/geoip
    GeoIPv6File $TBDATA_IN_STORE/geoip6
    EOF

    # Configure pluggable transports
    substituteInPlace $TBDATA_PATH/torrc-defaults \
      --replace "./TorBrowser/Tor/PluggableTransports/obfs4proxy" \
                "${obfs4}/bin/obfs4proxy"


    wrapper_XDG_DATA_DIRS=${concatMapStringsSep ":" (x: "${x}/share") [
      gnome3.adwaita-icon-theme
      shared-mime-info
    ]}
    wrapper_XDG_DATA_DIRS+=":"${concatMapStringsSep ":" (x: "${x}/share/gsettings-schemas/${x.name}") [
      glib
      gsettings-desktop-schemas
      gtk3
    ]};

    # Generate wrapper
    mkdir -p $out/bin
    cat > "$out/bin/tor-browser" << EOF
    #! ${runtimeShell}
    set -o errexit -o nounset

    umask 077

    PATH=${makeBinPath [ coreutils ]}
    export LC_ALL=C.UTF-8

    # Enter local state directory.
    REAL_HOME=\$HOME
    TBB_HOME=\''${TBB_HOME:-''${XDG_DATA_HOME:-\$REAL_HOME/.local/share}/tor-browser}
    HOME=\$TBB_HOME

    mkdir -p "\$HOME"
    cd "\$HOME"

    # unlike -bin variant, we force these into TBB_HOME
    # Re-init XDG basedir envvars
    XDG_CACHE_HOME=\$HOME/.cache
    XDG_CONFIG_HOME=\$HOME/.config
    XDG_DATA_HOME=\$HOME/.local/share
    XDG_RUNTIME_DIR="\$HOME/run"

    # Initialize empty TBB runtime state directory hierarchy.  Mirror the
    # layout used by the official TBB, to avoid the hassle of working
    # against the assumptions made by tor-launcher & co.
    mkdir -p "\$HOME/TorBrowser" "\$HOME/TorBrowser/Data"

    # Initialize the Tor data directory.
    mkdir -p "\$HOME/TorBrowser/Data/Tor"

    # TBB will fail if ownership is too permissive
    chmod 0700 "\$HOME/TorBrowser/Data/Tor"

    # Initialize the browser profile state.  Expect TBB to generate all data.
    mkdir -p "\$HOME/TorBrowser/Data/Browser/profile.default"
    # XXX: bookmarks?

    # Files that capture store paths; re-generated by firefox at startup
    # XXX: -bin variant leaves startupCache
    rm -rf "\$HOME/TorBrowser/Data/Browser/profile.default"/{compatibility.ini,extensions.ini,extensions.json,startupCache}

    ${optionalString pulseaudioSupport ''
      # Figure out some envvars for pulseaudio
      : "\''${PULSE_SERVER:=\$XDG_RUNTIME_DIR/pulse/native}"
      : "\''${PULSE_COOKIE:=\$XDG_CONFIG_HOME/pulse/cookie}"
    ''}

    # Font cache files capture store paths; clear them out on the off
    # chance that TBB would continue using old font files.
    rm -rf "\$HOME/.cache/fontconfig"

    # Lift-off!
    #
    # TZ is set to avoid stat()ing /etc/localtime over and over ...
    #
    # DBUS_SESSION_BUS_ADDRESS is inherited to avoid auto-launching a new
    # dbus instance; to prevent using the session bus, set the envvar to
    # an empty/invalid value prior to running tor-browser.
    #
    # FONTCONFIG_FILE is required to make fontconfig read the TBB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    #
    # HOME, TMPDIR, XDG_*_HOME are set as a form of soft confinement;
    # ideally, tor-browser should not write to any path outside TBB_HOME
    # and should run even under strict confinement to TBB_HOME.
    #
    # XDG_DATA_DIRS is set to prevent searching system directories for
    # mime and icon data.
    #
    # PULSE_{SERVER,COOKIE} is necessary for audio playback w/pulseaudio
    #
    # APULSE_PLAYBACK_DEVICE is for audio playback w/o pulseaudio (no capture yet)
    #
    # TOR_* is for using an external tor instance
    #
    # Parameters lacking a default value below are *required* (enforced by
    # -o nounset).
    exec env -i \
      \
      TZ=":" \
      TZDIR="\''${TZDIR:-}" \
      \
      DISPLAY="\$DISPLAY" \
      XAUTHORITY="\''${XAUTHORITY:-}" \
      DBUS_SESSION_BUS_ADDRESS="\$DBUS_SESSION_BUS_ADDRESS" \
      \
      HOME="\$HOME" \
      TMPDIR="\$XDG_CACHE_HOME/tmp" \
      XDG_CONFIG_HOME="\$XDG_CONFIG_HOME" \
      XDG_DATA_HOME="\$XDG_DATA_HOME" \
      XDG_CACHE_HOME="\$XDG_CACHE_HOME" \
      XDG_RUNTIME_DIR="\$HOME/run" \
      \
      XDG_DATA_DIRS="$wrapper_XDG_DATA_DIRS" \
      \
      PULSE_SERVER="\''${PULSE_SERVER:-}" \
      PULSE_COOKIE="\''${PULSE_COOKIE:-}" \
      \
      APULSE_PLAYBACK_DEVICE="\''${APULSE_PLAYBACK_DEVICE:-plug:dmix}" \
      \
      TOR_SKIP_LAUNCH="\''${TOR_SKIP_LAUNCH:-}" \
      TOR_CONTROL_PORT="\''${TOR_CONTROL_PORT:-}" \
      TOR_SOCKS_PORT="\''${TOR_SOCKS_PORT:-}" \
      \
      FONTCONFIG_FILE="$TBDATA_IN_STORE/fonts.conf" \
      \
      LD_LIBRARY_PATH="$libPath" \
      \
      $self/firefox \
        --class "Tor Browser" \
        -no-remote \
        -profile "\$HOME/TorBrowser/Data/Browser/profile.default" \
        "\''${@}"
    EOF
    chmod +x $out/bin/tor-browser

    # Install .desktop item
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    sed -i $out/share/applications/torbrowser.desktop \
        -e "s,Exec=.*,Exec=$out/bin/tor-browser," \
        -e "s,Icon=.*,Icon=web-browser,"

    echo "Syntax checking wrapper ..."
    bash -n $out/bin/tor-browser

    echo "Checking tor-browser wrapper ..."
    DISPLAY="" XAUTHORITY="" DBUS_SESSION_BUS_ADDRESS="" TBB_HOME=$(mktemp -d) \
      $out/bin/tor-browser --version >/dev/null
  '';

  passthru.execdir = "/bin";
  meta = with stdenv.lib; {
    description = "An unofficial version of the Tor Browser Bundle, built from source";
    longDescription = ''
      Tor Browser Bundle is a bundle of the Tor daemon, Tor Browser (heavily patched version of
      Firefox), several essential extensions for Tor Browser, and some tools that glue those
      together with a convenient UI.

      `tor-browser-bundle-bin` package is the official version built by torproject.org patched with
      `patchelf` to work under nix and with bundled scripts adapted to the read-only nature of
      the `/nix/store`.

      `tor-browser-bundle` package is the version built completely from source. It reuses the `tor`
      package for the tor daemon, `firefoxPackages.tor-browser` package for the tor-browser, and
      builds all the extensions from source.

      Note that `tor-browser-bundle` package is not only built from source, but also bundles Tor
      Browser differently from the official `tor-browser-bundle-bin` implementation. The official
      Tor Browser is not a normal UNIX program and is heavily patched for its use in the Tor Browser
      Bundle (which `tor-browser-bundle-bin` package then has to work around for the read-only
      /nix/store). Meanwhile, `firefoxPackages.tor-browser` reverts all those patches, allowing
      `firefoxPackages.tor-browser` to be used independently of the bundle, and then implements what
      `tor-browser-bundle` needs for the bundling using a much simpler patch. See the
      longDescription and expression of the `firefoxPackages.tor-browser` package for more info.
    '';
    inherit (tor-browser-unwrapped.meta) homepage platforms license;
    hydraPlatforms = [ ];
    maintainers = with maintainers; [ joachifm ];
  };
}
