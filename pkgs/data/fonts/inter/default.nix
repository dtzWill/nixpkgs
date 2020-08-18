{ lib, fetchzip }:

let
  version = "3.14";
in fetchzip {
  name = "inter-${version}";

  url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0kng9dnbbffp7i3ifhm3hn8khchs6528mb4601805ga9fnsp9daf";

  meta = with lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}

