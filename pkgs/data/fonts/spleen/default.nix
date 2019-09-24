{ lib, fetchurl }:

let
  pname = "spleen";
  version = "1.4.0";
in fetchurl rec {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    install -Dm644 *.{pcf.gz,psfu,bdf} -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias
  '';
  sha256 = "06j7bn5q16rzgxhgc2ad7x62szk45pbl1n28bc69bfl4h703np14";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
