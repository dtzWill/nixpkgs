{ stdenv, fetchFromGitHub, fetchpatch, mkfontdir }:

stdenv.mkDerivation rec {
  pname = "scientifica";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "NerdyPepper";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y3nlgxx5f4fr83vi8p2n53vvkkbhyf3a4sy6g6iv9qlspz4bajh";
  };

  # XXX: remove on update
  patches = [ (fetchpatch {
    name = "fix-FONT-value.patch";
    url = "https://github.com/NerdyPepper/scientifica/commit/5522d4f8fb471f3ea0d93819b239f1344802e497.patch";
    sha256 = "13fgdvp0hdx3kmknrg3azpmw684kh0kq5g8l9hmk6n99n4b72436";
  }) ];

  dontBuild = true;

  nativeBuildInputs = [ mkfontdir ];

  installPhase = ''
    install -Dt $out/share/fonts/misc **/*.otb
    install -Dt $out/share/fonts/bdf **/*.bdf

    # create fonts.dir so NixOS xorg module adds to fp
    mkfontdir $out/share/fonts/*
  '';

  meta = with stdenv.lib; {
    description = "scientifica font";
    homepage = https://github.com/NerdyPepper/scientifica;
    license = licenses.ofl;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}


