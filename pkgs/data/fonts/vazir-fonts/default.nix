{ lib, fetchFromGitHub }:

let
  pname = "vazir-fonts";
  version = "21.2.1";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rastikerdar";
  repo = "vazir-font";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/vazir-fonts {} \;
  '';
  sha256 = "10sdr3zknf7ki41i3373n4y7rl7ymbz87vvc0jbx4qrpvfnlbv30";

  meta = with lib; {
    homepage = https://github.com/rastikerdar/vazir-font;
    description = "A Persian (Farsi) Font - قلم (فونت) فارسی وزیر";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.linarcx ];
  };
}
