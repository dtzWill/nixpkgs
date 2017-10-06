{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "wireless-tools-${version}";
  version = "30.pre2";

  src = fetchurl {
    url = "http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.${version}.tar.gz";
    sha256 = "01lgf592nk8fnk7l5afqvar4szkngwpgcv4xh58qsg9wkkjlhnls";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out CC=cc LDCONFIG=:)
  ";

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
