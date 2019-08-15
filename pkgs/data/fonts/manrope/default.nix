{ lib, fetchFromGitHub }:

let
  pname = "manrope";
  version = "4";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "sharanda";
  repo = pname;
  rev = "0c04706136bf392895697bb7d76a4e659ac4d85d";
  sha256 = "0jkq15053b0a8pl6320q4nzjh4h6vkyy9hjz7ihq87ipl9m4wzzp";
  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm644 -t $out/share/fonts/opentype "fonts"/otf/*
  '';
  meta = with lib; {
    description = "Open-source modern sans-serif font family";
    homepage = https://github.com/sharanda/manrope;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
