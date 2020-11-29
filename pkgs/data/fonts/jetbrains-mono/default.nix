{ lib, fetchzip }:

let
  version = "2.200";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  #url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "00z651lpsksvhnyniyqsxax378wzkb6plfc5x8z95vrms6qh3jwv";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
