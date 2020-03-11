{ lib, fetchzip }:

let
  version = "1.0.4";
in
fetchzip rec {
  name = "JetBrainsMono-${version}";

  #url = "https://download.jetbrains.com/fonts/JetBrainsMono-${version}.zip";
  url = "https://github.com/JetBrains/JetBrainsMono/releases/download/v${version}/JetBrainsMono-${version}.zip";

  sha256 = "0w22dcb8zxyx8cgwn4fdi0wgqxvqnsr9vn0islrh5kbrd7qwc1l9";

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
