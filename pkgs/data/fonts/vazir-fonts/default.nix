{ lib, fetchFromGitHub }:

let
  pname = "vazir-fonts";
  version = "21.1.1";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/vazir-fonts {} \;
  '';
  sha256 = "00lxn91h439x3q05sprl29k4bc966cy2ds8dy9i4kxmcs3xzq167";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/vazir-font;
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
