{ stdenv, fetchurl, SDL2, SDL2_mixer, SDL2_image, SDL2_ttf }:

stdenv.mkDerivation rec {
  pname = "lbreakouthd";
  version = "1.0.5";

  buildInputs = [ SDL2 SDL2_mixer SDL2_image SDL2_ttf ];

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    sha256 = "18c47jvwpyyb08lmh6qkga24amvjnmqd6qkj1kihr1lfzv6nwagk";
  };

  hardeningDisable = [ "format" ]; # TODO: Investigate, fix!

  meta = with stdenv.lib; {
    description = "Breakout clone from the LGames series, scalable remake.";
    homepage = http://lgames.sourceforge.net/LBreakoutHD/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ciil dtzWill ];
    platforms = platforms.unix;
  };
}
