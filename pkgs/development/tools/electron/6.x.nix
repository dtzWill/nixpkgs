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
  # GENERATED
hashes = {
  x86_64-linux = "7fe94fc1edebe2f5645056a4300fc642c04155e55da8dd4ee058a0c0ef835ae8";
  x86_64-darwin = "1c790a4cbda05f1c136d18fa6a09bdb09a1941f521207466756a3e95e343c485";
  i686-linux = "1afd8ea79acb2b4782fb459e084549ed4cd4ead779764829b1d862148359eae5";
  armv7l-linux = "14f2ea0459f0dda8c566b0fa4a2fe755f4220bbae313ea0c453861ac2f803196";
  aarch64-linux = "80e05c1a0b51c335483666e959c1631a089246986b7fc3a4f9ee1288a57a602a";
};
  # -----------------------------


  get = as: platform: as.${platform.system} or
    "Unsupported system: ${platform.system}";

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
