{ lib, fetchzip }:

let
  version = "3.5";
in fetchzip {
  name = "inter-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype/
    unzip -j $downloadedFile "Inter (TTF variable)/*.ttf" -d $out/share/fonts/truetype
  '';

  sha256 = "190crrmp8i7vadl0npfzxywj78q8szc4y2gdcmjbi74q76xb0cc9";

  meta = with lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}

