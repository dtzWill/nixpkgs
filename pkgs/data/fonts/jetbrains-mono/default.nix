{ lib, fetchzip }:

let
  version = "1.0.1";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  # url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/${version}/JetBrainsMono-${version}.zip";

  sha256 = "1n6pin0mrr5gzjd9lbprnjifbjdvkp9c8b4psixd1ryl1shf91ip";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ttf/*.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
