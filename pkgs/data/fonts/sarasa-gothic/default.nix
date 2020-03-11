{ lib, fetchurl, p7zip }:

let
  version = "0.11.0";
in fetchurl rec {
  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "03zn113x0d37bys38g0rrka0z1a333mjy3qvj5kwpayppnzzsdr1";

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
