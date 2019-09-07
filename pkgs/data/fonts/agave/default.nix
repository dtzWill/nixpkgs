{ lib, fetchurl }:

let
  pname = "agave";
  version = "13";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-Regular.ttf";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/truetype/Agave-Regular.ttf
  '';

  sha256 = "0sblqi67hjhwd3i18z59a2phz7sbjljb95fa1haay92jqhsjs3fw";

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = https://b.agaric.net/page/agave;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

