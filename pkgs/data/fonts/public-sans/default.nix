{ lib, fetchzip }:

let
  version = "1.007";
in fetchzip rec {
  name = "public-sans-${version}";

  url = "https://github.com/uswds/public-sans/releases/download/v${version}/public-sans-v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/{opentype,truetype}
    unzip -j $downloadedFile binaries/otf/\*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile binaries/variable/\*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0j9kwq80km0ai3gipzq5h66y6crkqczbfdh9s9mgx8h2n0vaivfa";

  meta = with lib; {
    description = "A strong, neutral, principles-driven, open source typeface for text or display";
    homepage = https://public-sans.digital.gov/;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
