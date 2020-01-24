{ lib, fetchzip }:

let
  version = "1.0.2";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";

  sha256 = "04diyyhmlzx8dcrna334afrw4717hq2ijjz8g3jai9qliik8qcql";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype ${name}/ttf/*.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
