{ lib, stdenv, fetchurl, writeScript, appimageTools, buildFHSUserEnv,
  runtimeShell, makeFontsConf, twemoji-color-font }:

let
  pname = "ripcord";
  version = "0.4.23";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://cancel.fm/dl/Ripcord-${version}-x86_64.AppImage";
    sha256 = "0395w0pwr1cz8ichcbyrsscmm2p7srgjk4vkqvqgwyx41prm0x2h";
    name = "${pname}-${version}.AppImage";
  };

  fontsConf = makeFontsConf {
    fontDirectories = [
      twemoji-color-font
    ];
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in buildFHSUserEnv (appimageTools.defaultFhsEnvArgs // {
  inherit name;

  targetPkgs = pkgs: appimageTools.defaultFhsEnvArgs.targetPkgs pkgs ++ (with pkgs; [ ]);

  extraBuildCommands = ''
    # Begin patch to fix https://dev.cancel.fm/tktview?name=d2dc78360c
    chmod u+w ./etc

    # Realise fonts by one level
    rm ./etc/fonts && mkdir ./etc/fonts

    # Substitute fonts.conf
    ln -s ${fontsConf.out} ./etc/fonts/fonts.conf
  '';

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/Ripcord.desktop $out/share/applications/ripcord.desktop
    install -m 444 -D ${appimageContents}/Ripcord_Icon.png \
      $out/share/icons/hicolor/512x512/apps/ripcord.png
  '';

  runScript = writeScript "run" ''
    #!${runtimeShell}
    export APPDIR=${appimageContents}
    export APPIMAGE_SILENT_INSTALL=1
    cd $APPDIR
    exec ./AppRun "$@"
  '';

  meta = with lib; {
    description = "Desktop chat client for Slack and Discord";
    homepage = "https://cancel.fm/ripcord/";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ bqv ];
    platforms = [ "x86_64-linux" ];
  };
})
