{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core }:

let
  version = "5.0.9";
  name = "electron-${version}";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/electron/electron;
    license = licenses.mit;
    maintainers = with maintainers; [ travisbhartwell manveru ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ];
  };

  linux = {
    inherit name version meta;
    src = {
      i686-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-ia32.zip";
        sha256 = "0j7vdcixvsr2j48cprc4s65hmw3dfk2zydqslixk3kvk5ng80ncl";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
        sha256 = "1aivpj2wbg4qzvc01ks6fnwlayyyahcf2ywdxgkkg7iihcs4lkki";
      };
      armv7l-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-armv7l.zip";
        sha256 = "1n7zx1qa03plyzszspxkbalisw63q7ixidy7fbc7ipphxbfxjcls";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-arm64.zip";
        sha256 = "00lhk7vj75f2lss5n3rkdsjld671sjicp4bxx9hfsnr321kiq8ik";
      };
    }.${stdenv.hostPlatform.system} or throwSystem;

    buildInputs = [ gtk3 ];

    nativeBuildInputs = [
      unzip
      makeWrapper
      wrapGAppsHook
    ];

    dontWrapGApps = true; # electron is in lib, we need to wrap it manually

    buildCommand = ''
      mkdir -p $out/lib/electron $out/bin
      unzip -d $out/lib/electron $src
      ln -s $out/lib/electron/electron $out/bin

      fixupPhase

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${stdenv.lib.makeLibraryPath [ libuuid at-spi2-atk at-spi2-core ]}:$out/lib/electron" \
        $out/lib/electron/electron

      wrapProgram $out/lib/electron/electron \
        --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1 \
        "''${gappsWrapperArgs[@]}"
    '';
  };

  darwin = {
    inherit name version meta;

    src = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-darwin-x64.zip";
      sha256 = "1mvc2bb350vbp4h99m3f6agp7k59qcp8lxzk050qrw6ki24sxqrf";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      ln -s $out/Applications/Electron.app/Contents/MacOs/Electron $out/bin/electron
    '';
  };
in

  stdenv.mkDerivation (if stdenv.isDarwin then darwin else linux)
