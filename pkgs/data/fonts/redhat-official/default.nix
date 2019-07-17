{ lib, fetchzip }:

let version = "2.3.1"; in
fetchzip rec {
  name = "redhat-official-${version}";
  url = "https://github.com/RedHatOfficial/RedHatFont/archive/${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  hash = "sha256-2C9etPsNLB3v6N9qeM+HtdUy6Xhp0TRVgsUzo2AimpY=";

  meta = with lib; {
    homepage = https://github.com/RedHatOfficial/RedHatFont;
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
