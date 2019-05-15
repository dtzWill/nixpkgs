{ lib, fetchzip }:

let
  baseName = "gyre-fonts";
  version = "2.5001";
in fetchzip {
  name="${baseName}-${version}";

  url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg2_501otf.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "19hw2s30fdw4mxni3m7kiaav0dld20blys1jickd6gbqm7lxhnf6";

  meta = {
    description = "OpenType fonts from the Gyre project, suitable for use with (La)TeX";
    longDescription = ''
      The Gyre project started in 2006, and will
      eventually include enhanced releases of all 35 freely available
      PostScript fonts distributed with Ghostscript v4.00.  These are
      being converted to OpenType and extended with diacritical marks
      covering all modern European languages and then some
    '';
    homepage = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/index_html#Readings";
    license = lib.licenses.lppl13c;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey ];
  };
}
