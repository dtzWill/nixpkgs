{ lib, fetchurl, p7zip }:

let
  version = "0.10.2";
in fetchurl rec {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "0wkz0rw88b0fl2flfgx243z1zs9n42igq5mdlm2rm0w8zds81c5k";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile -o$out/share/fonts
  '';

  meta = with lib; {
    description = "SARASA GOTHIC is a Chinese & Japanese programming font based on Iosevka and Source Han Sans";
    homepage = https://github.com/be5invis/Sarasa-Gothic;
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
  };
}
