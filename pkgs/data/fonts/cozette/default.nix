{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.7.0";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "1if3n3psri5kwq7p0vn951jxlkhrln82gym3fl924ia458wpv6b6";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "07kxxyjgzjj08i0107a6qszq29i15swza8bnd75b7fzm60p5fgyq";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "1b81q28afg0kyf7k2lglnd2whafnldl7zmdabzjb4nvjwnx7f9kl";
    }
  ];

  nativeBuildInputs = [ mkfontscale ];

  sourceRoot = "./";

  unpackCmd = ''
    otName=$(stripHash "$curSrc")
    cp $curSrc ./$otName
  '';

  installPhase = ''

    install -D -m 644 *.otf -t "$out/share/fonts/opentype"
    install -D -m 644 *.ttf -t "$out/share/fonts/truetype"
    install -D -m 644 *.otb -t "$out/share/fonts/misc"

    mkfontdir "$out/share/fonts/misc"
    mkfontscale "$out/share/fonts/truetype"
    mkfontscale "$out/share/fonts/opentype"
  '';

  outputs = [ "out" ];

  meta = with stdenv.lib; {
    description = "A bitmap programming font optimized for coziness.";
    homepage = "https://github.com/slavfox/cozette";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ brettlyons ];
  };
}
