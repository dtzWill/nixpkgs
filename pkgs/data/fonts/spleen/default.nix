{ lib, fetchurl, netbsd, xorg }:

let
  pname = "spleen";
  version = "1.0.4-git";
in fetchurl rec {
  name = "${pname}-${version}";
  url = "https://github.com/fcambus/spleen/archive/cf8f381541f850825bd4bf33f20c226a8eaa0a75.tar.gz";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    tar xf $downloadedFile --strip=1
    d="$out/share/fonts/X11/misc/spleen"
    export PATH=$PATH:${xorg.bdftopcf}/bin
    ${netbsd.makeMinimal}/bin/make pcf
    gzip -n9 *.pcf
    install -Dm644 *.pcf.gz  -t $d
    install -Dm644 *.bdf -t $d
    install -m644 fonts.alias-spleen $d/fonts.alias
  '';
  sha256 = "0wcc4ldyrywj988dqq5i9mmmm7dslnijbb75a0wmj2px41kzb5w4";

  meta = with lib; {
    description = "Monospaced bitmap fonts";
    homepage = https://www.cambus.net/spleen-monospaced-bitmap-fonts;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
  };
}
