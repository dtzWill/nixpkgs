{ lib, fetchFromGitHub }:

let
  pname = "manrope";
  version = "4";
in fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "sharanda";
  repo = pname;
  rev = "6db3ce008d2f802db6abbf9ec7bebec169c4d345";
  sha256 = "0khr161ip18ng3r8vgx0lh1br43la4fq0a3wa0kh5hyx6f1vh536";
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
