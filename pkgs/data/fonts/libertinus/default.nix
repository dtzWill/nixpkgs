{ lib, fetchFromGitHub }:

let
  version = "6.10";
in fetchFromGitHub rec {
  name = "libertinus-${version}";

  owner  = "alif-type";
  repo   = "libertinus";
  rev    = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${name}    *.txt
  '';
  sha256 = "1lfc93pigs9dm9fp7x43d9h8yspv13iy1w4scigdil8flw224kxj";

  meta = with lib; {
    description = "A fork of the Linux Libertine and Linux Biolinum fonts";
    longDescription = ''
      Libertinus fonts is a fork of the Linux Libertine and Linux Biolinum fonts
      that started as an OpenType math companion of the Libertine font family,
      but grown as a full fork to address some of the bugs in the fonts.
    '';
    homepage = https://github.com/alif-type/libertinus;
    license = licenses.ofl;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
