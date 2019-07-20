{ theme ? null, stdenv, fetchurl, dpkg, makeWrapper , alsaLib, atk, cairo,
cups, curl, dbus, expat, fontconfig, freetype, glib , gnome2, gtk3, gdk_pixbuf,
libappindicator-gtk3, libnotify, libxcb, nspr, nss, pango , systemd, xorg,
at-spi2-atk, libuuid, asar
}:

let

  version = "4.0.0";

  rpath = stdenv.lib.makeLibraryPath [
    alsaLib
    at-spi2-atk
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    gnome2.GConf
    gdk_pixbuf
    gtk3
    pango
    libnotify
    libxcb
    libappindicator-gtk3
    nspr
    nss
    stdenv.cc.cc
    systemd
    libuuid

    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
  ] + ":${stdenv.cc.cc.lib}/lib64";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://downloads.slack-edge.com/linux_releases/slack-desktop-${version}-amd64.deb";
        sha256 = "0znmgga82qwvq5yi7jy9c8c1f38b8j13w09zy4fii1agzc2lq6li";
      }
    else
      throw "Slack is not supported on ${stdenv.hostPlatform.system}";

in stdenv.mkDerivation {
  pname = "slack";
  inherit src version;

  buildInputs = [
    dpkg
    gtk3  # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [ makeWrapper asar ];

  dontUnpack = true;
  buildCommand = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/usr/* $out
    rm -rf $out/etc $out/usr $out/share/lintian

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/slack $file || true
    done

    # Replace the broken bin/slack symlink with a startup wrapper
    rm $out/bin/slack
    makeWrapper $out/lib/slack/slack $out/bin/slack \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/
  '' + stdenv.lib.optionalString (theme != null) ''
    cat <<EOF >> $out/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js
    document.addEventListener('DOMContentLoaded', function() {
    let tt__customCss = ".menu ul li a:not(.inline_menu_link) {color: #fff !important;}"
    $.ajax({
        url: '${theme}/theme.css',
        success: function(css) {
            \$("<style></style>").appendTo('head').html(css + tt__customCss);
            \$("<style></style>").appendTo('head').html('#reply_container.upload_in_threads .inline_message_input_container {background: padding-box #545454}');
            \$("<style></style>").appendTo('head').html('.p-channel_sidebar {background: #363636 !important}');
            \$("<style></style>").appendTo('head').html('#client_body:not(.onboarding):not(.feature_global_nav_layout):before {background: inherit;}');
        }
      });
    });
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = https://slack.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
