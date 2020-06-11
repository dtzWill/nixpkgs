{ stdenv, fetchurl, mkfontscale }:

let
  version = "1.8.2";
  releaseUrl =
    "https://github.com/slavfox/Cozette/releases/download/v.${version}";
in stdenv.mkDerivation rec {
  pname = "Cozette";
  inherit version;

  # TODO: font files are available together in release now, as of 1.8.1
  srcs = map fetchurl [
    {
      url = "${releaseUrl}/cozette.otb";
      sha256 = "0prmbqls2vz2xm5zq64kgvksbwh49a2r2kx5zdc20y5g3cbp6986";
    }
    {
      url = "${releaseUrl}/CozetteVector.otf";
      sha256 = "160ij61j0xig8q41a10432iabfwhgbp50gakh995mjnlvj6zasqw";
    }
    {
      url = "${releaseUrl}/CozetteVector.ttf";
      sha256 = "1z1fm1wr7sy0pvkx3hl3q9m0djvd4x9drkpp0y4d87x2cp78b2bc";
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
