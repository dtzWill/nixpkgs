{ stdenv, fetchurl, dmg2img, p7zip, libicns, makeWrapper, electron }:

stdenv.mkDerivation rec {
  pname = "notion-app";
  version = "2.0.5";

  src = fetchurl {
    url = "https://desktop-release.notion-static.com/Notion-${version}.dmg";
    sha256 = "04bks8b6pk7awq0p4jjqg6dvf87wslqfda6hcn5j7rzk9ck31fki";
  };

  unpackPhase = ''
    runHook preUnpack

    dmg2img ${src} -o notion-${version}.img
    7z x -y notion-${version}.img

    runHook postUnpack
  '';

  nativeBuildInputs = [ dmg2img p7zip libicns makeWrapper ];

  buildPhase = ''
    runHook preBuild

    mkdir -p tmp/build
    cp -r Notion**/Notion.app/Contents/Resources/* tmp/build
    icns2png -x tmp/build/Notion.icns

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/notion-app/
    cp -vr tmp/build/* $out/share/notion-app/

    # share/icons?
    cp -v Notion_512x512x32.png $out/share/notion-app/

    makeWrapper ${electron}/bin/electron $out/bin/notion-app \
      --run "cd $out/share/notion-app" \
      --add-flags "$out/share/notion-app/app.asar"

    runHook postInstall
  '';
}
