{ stdenv, libXScrnSaver, makeWrapper, fetchurl, wrapGAppsHook, gtk3, unzip, atomEnv, libuuid, at-spi2-atk, at-spi2-core}:

let
  version = "6.1.7";
  name = "electron-${version}";

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/electron/electron;
    license = licenses.mit;
    maintainers = with maintainers; [ travisbhartwell manveru ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ];
  };

  # -----------------------------
  # XXX: version-agnostic, hoist!
  fetcher = vers: tag: hash: fetchurl {
    url = "https://github.com/electron/electron/releases/download/v${vers}/electron-v${vers}-${tag}.zip";
    sha256 = hash;
  };
  tags = {
    i686-linux = "linux-ia32";
    x86_64-linux = "linux-x64";
    armv7l-linux = "linux-armv7l";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
  };
  # -----------------------------

  # -----------------------------
  # XXX: version-specific, generate this with ./print-hashes.sh
  hashes = {
    i686-linux = "1hikg5gn1x35cp77lnsr4i9k4m2n0h88js277ql6fwwxsrrymvcq";
    x86_64-linux = "0ihgjhphq9xiacgn63rxq764yypm9d3q054xlny7h9n9h539l4yd";
    armv7l-linux = "1111111111111111111111111111111111111111111111111111";
    aarch64-linux = "1111111111111111111111111111111111111111111111111111";
    x86_64-darwin = "1111111111111111111111111111111111111111111111111111";
  };
  get = as: platform: as.${platform.system} or
    "Unsupported system: ${platform.system}";
  # -----------------------------

  common = platform: {
    inherit name version meta;
    src = fetcher version (get tags platform) (get hashes platform);
  };

  linux = {
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
  stdenv.mkDerivation (
    (common stdenv.hostPlatform) //
    (if stdenv.isDarwin then darwin else linux)
  )
