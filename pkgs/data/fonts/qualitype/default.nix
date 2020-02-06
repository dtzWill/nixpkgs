{ stdenv, fetchzip, lib }:

fetchzip {
  name = "qualitype-fonts";

  url = "http://luc.devroye.org/QT-OTF.zip";
  sha256 = "0czjs2yvd475wi03x5zld87c5f00ss0vkbs3f3qpd5gp7kibj8vb";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  meta = with lib; {
    homepage = "http://luc.devroye.org/fonts-26839.html";
    description = "QualiType font collection";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
