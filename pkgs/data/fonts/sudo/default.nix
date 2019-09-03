{ lib, fetchzip, variableFont ? true }:

let
  version = "0.40";
  pattern = if variableFont
    then ''\*/SudoVariable.ttf''
    else ''\*/Sudo-\*.ttf'';
  sha256 = if variableFont
    then "06k2p10ag2izzby0ziwwqx6mqx8f4kj9bmnxfz8rwdigj6p7iril"
    else "1c1821kwlh8kql1n5713y82rwfk99bi5wq4ya0sg4dvk1y3kjzwi";
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

