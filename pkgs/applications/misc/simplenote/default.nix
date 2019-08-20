{ fetchurl, stdenv, lib, zlib, glib, alsaLib, dbus, gtk3, atk, pango, freetype, fontconfig
, libgnome-keyring3, gdk_pixbuf, cairo, cups, expat, libgpgerror, nspr
, nss, xorg, libcap, systemd, at-spi2-atk, libnotify, libuuid, libXScrnSaver, gnome2 }:

let version = "1.6.0"; in

stdenv.mkDerivation rec {

  pname = "simplenote";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${version}/Simplenote-linux-${version}-x64.tar.gz";
    sha256 = "1awvz6f9z97cvynjakm6ajvkz3c6fwcbc23n8gmk9qk3k8pj3krf";
  };

  buildCommand = let

    packages = [
      stdenv.cc.cc zlib glib dbus gtk3 atk pango freetype libgnome-keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr nss
      xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
      xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
      xorg.libXcursor libcap systemd at-spi2-atk libnotify libuuid libXScrnSaver gnome2.GConf
      xorg.libxcb
    ];

    libPathNative = lib.makeLibraryPath packages;
    libPath64 = lib.makeSearchPathOutput "lib" "lib64" packages;
    libPath = "${libPathNative}:${libPath64}";

  in ''
    mkdir -p $out/share/
    mkdir -p $out/bin
    tar xvzf $src -C $out/share/
    mv $out/share/Simplenote-linux-${version}-x64 $out/share/simplenote
    mkdir -p $out/share/applications

    cat > $out/share/applications/simplenote.desktop << EOF
    [Desktop Entry]
    Name=Simplenote
    Comment=Simplenote for Linux
    Exec=$out/bin/simplenote
    Icon=$out/share/simplenote/Simplenote.png
    Type=Application
    StartupNotify=true
    Categories=Development;
    EOF

    fixupPhase

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}:$out/share/simplenote" \
      $out/share/simplenote/simplenote

    ln -s $out/share/simplenote/simplenote $out/bin/simplenote
  '';

  meta = with stdenv.lib; {
    description = "The simplest way to keep notes";
    homepage = https://github.com/Automattic/simplenote-electron;
    license = licenses.lgpl2;
    platforms = [ "x86_64-linux" ];
  };
}
