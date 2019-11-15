{ lib, fetchurl, mkfontdir }:

let
  pname = "spleen";
  version = "1.5.0";
in fetchurl rec {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/releases/download/${version}/spleen-${version}.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xvf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    install -Dm644 *.{pcf.gz,bdf} -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias

    # create fonts.dir so NixOS xorg module adds to fp
    ${mkfontdir}/bin/mkfontdir $d

    # psfu -> consolefonts
    install -Dm644 *.psfu -t $out/share/consolefonts
  '';
  sha256 = "0rjlnpklx58sma3b9pvw90s31ya5dk7cynk4ihgs7fh458ijjrcx";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
