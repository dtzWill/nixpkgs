{ lib, fetchFromGitHub }:

let
  pname = "manrope";
  version = "4.2020.01.09";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "sharanda";
  repo = pname;
  rev = "dc0fd644d52ec11853bf2930245c1c2e733a18e9";
  sha256 = "1gawwhi9ayrwxyp1hvs31w7rhfwvysqfvxi2vhghs016n4blbp33";
  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm644 -t $out/share/fonts/opentype fonts/otf/*
    install -Dm644 -t $out/share/fonts/truetype fonts/ttf/* fonts/variable/*.ttf
  '';
  meta = with lib; {
    description = "Open-source modern sans-serif font family";
    homepage = https://github.com/sharanda/manrope;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
