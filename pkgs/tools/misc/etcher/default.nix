{ lib
, stdenv
, fetchurl
, dpkg
, polkit
, bash
, nodePackages
, electron
, gtk3
, wrapGAppsHook
}:

let
  libPath = lib.makeLibraryPath [
    # for libstdc++.so.6
    stdenv.cc.cc
  ];

  sha256 = {
    "x86_64-linux" = "14bnxsd6cb819sav1w0sdgbshsqz7dgxmcirn92i6bhclk4kb8ym";
    "i686-linux" = "16kkqdglapw4p7wd1bzxypm8jsdb05v9b1lnwky20qk8ymnv2ysh";
  }."${stdenv.system}";

  arch = {
    "x86_64-linux" = "amd64";
    "i686-linux" = "i386";
  }."${stdenv.system}";

in stdenv.mkDerivation rec {
  pname = "etcher";
  version = "1.5.73";

  src = fetchurl {
    url = "https://github.com/balena-io/etcher/releases/download/v${version}/balena-etcher-electron_${version}_${arch}.deb";
    inherit sha256;
  };

  buildInputs = [
    gtk3
  ];

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  # sudo-prompt has hardcoded binary paths on Linux and we patch them here
  # along with some other paths
  patchPhase = ''
    ${nodePackages.asar}/bin/asar extract opt/balenaEtcher/resources/app.asar tmp
    # Use Nix(OS) paths
    sed -i "s|/usr/bin/pkexec|/usr/bin/pkexec', '/run/wrappers/bin/pkexec|" tmp/node_modules/sudo-prompt/index.js
    sed -i 's|/bin/bash|${bash}/bin/bash|' tmp/node_modules/sudo-prompt/index.js
    sed -i "s|process.resourcesPath|'$out/opt/balenaEtcher/resources/'|" tmp/generated/gui.js
    ${nodePackages.asar}/bin/asar pack tmp opt/balenaEtcher/resources/app.asar
    rm -rf tmp
    # Fix up .desktop file
    substituteInPlace usr/share/applications/balena-etcher-electron.desktop \
      --replace "/opt/balenaEtcher/balena-etcher-electron" "$out/bin/balena-etcher-electron"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out/
    cp -r usr/share $out/

    # We'll use our Nixpkgs electron
    rm $out/opt/balenaEtcher/balena-etcher-electron

    ln -s ${electron}/bin/electron $out/bin/balena-etcher-electron
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --add-flags $out/opt/balenaEtcher/resources/app.asar
      --prefix LD_LIBRARY_PATH : ${libPath}
    )
  '';

  meta = with stdenv.lib; {
    description = "Flash OS images to SD cards and USB drives, safely and easily";
    homepage = "https://etcher.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.shou ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
