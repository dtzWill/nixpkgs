{ stdenv, fetchFromGitHub, mkfontdir }:

stdenv.mkDerivation rec {
  pname = "curie";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q5piflsph00kr0c3pkwn50p2x8fksmlrjl19zwback0kvihz3aj";
  };

  dontBuild = true;

  nativeBuildInputs = [ mkfontdir ];

  installPhase = ''
    install -Dt $out/share/fonts/misc {regular,bold,italic}/*.otb
    install -Dt $out/share/fonts/bdf {regular,bold,italic}/*.bdf

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir $out/share/fonts/*
  '';

  meta = with stdenv.lib; {
    description = "upscaled scientifica font";
    homepage = https://github.com/NerdyPepper/curie;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}


