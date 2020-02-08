{ lib, fetchzip }:

let
  version = "1.0.3";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  #url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "07aziblb0mrvi4sinyb42si2b1sy5yp5l2d9n81gah4mnl0kfldw";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ${name}-Source/ttf/*.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
