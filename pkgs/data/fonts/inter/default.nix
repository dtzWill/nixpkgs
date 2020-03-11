{ lib, fetchzip }:

#let
#  version = "3.12";
#in fetchzip {
fetchzip {
  #name = "inter-${version}";
  name = "inter-3.12-display-alpha";

  # url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-${version}.zip";
  url = "https://github.com/rsms/inter/releases/download/v3.12-display-alpha/Inter-3.12-Display-1fcc00b62b.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "00p63f1glzz2a7fapcls89rgb7qmz4w646j294rpfsdcnxj62awx";

  meta = with lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize dtzWill ];
  };
}

