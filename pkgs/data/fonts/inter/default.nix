{ lib, fetchzip }:

let
  version = "3.5";
in fetchzip {
  name = "inter-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype/
    unzip -j $downloadedFile "Inter (TTF hinted)/*.ttf" "Inter (TTF variable)/*.ttf" -d $out/share/fonts/truetype
  '';

  sha256 = "0kyfz86nznrh3mk4f86mp1cfl5965xj5nc6qwp9srxhf6nri48xg";

  meta = with lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

