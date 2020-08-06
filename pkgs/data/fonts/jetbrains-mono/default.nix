{ lib, fetchzip }:

let
  version = "2.000";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  #url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrains.Mono.${version}.zip";

  sha256 = "1dc2m4f9vhddn0d8gcp1qa76gg1jqa0lqj739cr0ndx8ck5zq2rp";

  postFetch = ''
    unzip $downloadedFile
    install -m444 -Dt $out/share/fonts/truetype "JetBrains Mono ${version}"/ttf{,/Variable}/*.ttf
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
