{ stdenv, fetchurl, alsaLib, atk, cairo, cups, udev
, dbus, expat, fontconfig, freetype, gdk-pixbuf, glib, gtk3, libappindicator-gtk3
, libnotify, nspr, nss, pango, systemd, xorg, autoPatchelfHook, wrapGAppsHook
, runtimeShell, gsettings-desktop-schemas }:

let
  versionSuffix = "20200130211428.cf82db8320";
in

stdenv.mkDerivation rec {
  pname = "keybase-gui";
  version = "5.2.0"; # Find latest version from https://prerelease.keybase.io/deb/dists/stable/main/binary-amd64/Packages

  src = fetchurl {
    url = "https://prerelease.keybase.io/deb/pool/main/k/keybase/keybase_${version + "-" + versionSuffix}_amd64.deb";
    sha256 = "6bf96753ed2a62d563e1224f8ce9f385b1e03e443943ebeff2e78ddb710c0cb4"; # <-- hash from same URL as above
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libappindicator-gtk3
    libnotify
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];

  runtimeDependencies = [
    udev.lib
    libappindicator-gtk3
  ];

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;

  unpackPhase = ''
    ar xf $src
    tar xf data.tar.xz
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv usr/share $out/share
    mv opt/keybase $out/share/

    cat > $out/bin/keybase-gui <<EOF
    #!${runtimeShell}

    checkFailed() {
      if [ "\$NIX_SKIP_KEYBASE_CHECKS" = "1" ]; then
        return
      fi
      echo "Set NIX_SKIP_KEYBASE_CHECKS=1 if you want to skip this check." >&2
      exit 1
    }

    if [ ! -S "\$XDG_RUNTIME_DIR/keybase/keybased.sock" ]; then
      echo "Keybase service doesn't seem to be running." >&2
      echo "You might need to run: keybase service" >&2
      checkFailed
    fi

    if [ -z "\$(keybase status | grep kbfsfuse)" ]; then
      echo "Could not find kbfsfuse client in keybase status." >&2
      echo "You might need to run: kbfsfuse" >&2
      checkFailed
    fi

    exec $out/share/keybase/Keybase "\$@"
    EOF
    chmod +x $out/bin/keybase-gui

    substituteInPlace $out/share/applications/keybase.desktop \
      --replace run_keybase $out/bin/keybase-gui
  '';

  meta = with stdenv.lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official GUI";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvolosatovs puffnfresh np ];
    license = licenses.bsd3;
  };
}
