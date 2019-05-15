{ stdenv, fetchzip }:

let
  version = "2.0.1";
in fetchzip {
  name = "stix-two-${version}";

  url = "https://github.com/stipub/stixfonts/raw/master/zipfiles/STIXv${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "1k52scpr2cm6nz9jpj84q46wnz8fhi7qj37ci7cd09gsav42dvgh";

  meta = with stdenv.lib; {
    homepage = http://www.stixfonts.org/;
    description = "Fonts for Scientific and Technical Information eXchange";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
