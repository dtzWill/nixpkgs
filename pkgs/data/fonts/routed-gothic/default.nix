{ fetchzip }:

let
  pname = "routed-gothic";
  version = "1.0.0";
in fetchzip {
  name = "routed-gothic-${version}";
  url = "https://webonastick.com/fonts/${pname}/download/${pname}-ttf-v${version}.zip";
  sha256 = "0vqj1vqxlzf169ilxjg2wbvi6w57g15w4nvivg97hpzxd1dnnvs4";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
  '';

  #meta = with lib; {
  #};
}
