{ lib, fetchzip }:

let
  version = "0.51";
in fetchzip {
  name = "sudo-font-${version}";
  url = "https://github.com/jenskutilek/sudo-font/raw/v${version}/dist/sudo.zip";
  sha256 = "12jrh1jnhsyzjk6wn84yj35ji90iw0ap22l84mb60f6nq982mzq9";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype/
    unzip -j $downloadedFile \*.woff -d $out/share/fonts/woff/
    unzip -j $downloadedFile \*.woff2 -d $out/share/fonts/woff2/
  '';
  meta = with lib; {
    description = "Font for programmers and command line users";
    homepage = "https://www.kutilek.de/sudo-font/";
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}

