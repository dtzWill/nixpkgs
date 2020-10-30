{ lib, fetchurl }:

let
  pname = "agave";
  version = "34";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/blobject/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "1zkssics3a5cf64rbmh08my8s9ylw58l5kzpnjzcvhy6p3f2vacv";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

