{ lib, fetchzip }:

let version = "2.3.2"; in
fetchzip rec {
  name = "redhat-official-${version}";
  url = "https://github.com/RedHatOfficial/RedHatFont/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "15ls49ha6cy5h9ak9lb9g3lk5mdmhz7phsnzx3pisb0dzfs5wbyq";

  meta = with lib; {
    homepage = https://github.com/RedHatOfficial/RedHatFont;
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
