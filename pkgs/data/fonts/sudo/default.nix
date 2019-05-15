{ lib, fetchzip, variableFont ? true }:

let
  version = "0.38";
  pattern = if variableFont
    then ''\*/SudoVariable.ttf''
    else ''\*/Sudo-\*.ttf'';
  sha256 = if variableFont
    then "13l1bp4ym3743hc2mp5hiw928kv9g6gmsj4a2jf9wvfrakpfxxs5"
    else "05qz6r1j07q90xhmk3jsxh9bbyj03al0l60zgshf1fc4bzkcmrv6";
in fetchzip rec {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/releases/download/v${version}/sudo.zip";
  inherit sha256;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype/
    unzip -j $downloadedFile ${pattern} -d $out/share/fonts/truetype/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = https://www.kutilek.de/sudo-font/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

