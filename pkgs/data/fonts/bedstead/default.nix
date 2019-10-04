{ lib, fetchzip }:

let version = "002.000"; in
fetchzip rec {
  name = "bedstead-${version}";
  url = "https://bjh21.me.uk/bedstead/bedstead-${version}.zip";
  postFetch = ''
    mkdir -p $out/share/fonts/bedstead
    unzip -j $downloadedFile \*.otf \*.bdf -d $out/share/fonts/bedstead/
  '';
  sha256 = "07z79qrmwpdp4a684b7jas2d54v1rlsr49957cv6jphv4nb79cqy";

  meta = with lib; {
    # description = "outline fonts";
    # license =
    homepage = "https://bjh21.me.uk/bedstead/";
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
