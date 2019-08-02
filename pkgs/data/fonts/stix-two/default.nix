{ stdenv, fetchzip }:

let
  version = "2.0.2";
in fetchzip {
  name = "stix-two-${version}";

  url = "https://github.com/stipub/stixfonts/raw/master/zipfiles/STIXv${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0zm0jav22rna8qy09v8zx71xbmxrm7yc1slds6cwh6gcdbig8lv7";

  meta = with stdenv.lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
