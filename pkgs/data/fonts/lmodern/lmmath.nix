{ fetchzip }:

fetchzip {
  name = "lmmath-1.959";

  url = http://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip;

  postFetch = ''
    unzip $downloadedFile

    mkdir -p $out/texmf-dist/fonts/opentype
    mkdir -p $out/share/fonts/opentype

    cp */otf/*.otf $out/texmf-dist/fonts/opentype/lmmath-regular.otf
    cp */otf/*.otf $out/share/fonts/opentype/lmmath-regular.otf

    ln -s -r $out/texmf* $out/share/
  '';

  sha256 = "1aw4fk9xqblc2zjrc52nwmsmbs8328a8c77vvnxi32r5953b3ihb";

  meta = {
    description = "Latin Modern math font";
  };
}

