{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "dmidecode";
  version = "3.2";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1pcfhcgs2ifdjwp7amnsr3lq95pgxpr150bjhdinvl505px0cw07";
  };

  # Apply upstream's recommended patches, since they list them next to the source link
  patches = stdenv.lib.mapAttrsToList
  (r: h: fetchpatch {
    url = "https://git.savannah.gnu.org/cgit/dmidecode.git/patch/?id=${r}";
    sha256 = h;
  })
  {
    "fde47bb2" = "133nd0c72p68hnqs5m714167761r1pp6bd3kgbsrsrwdx40jlc3m";
    "74dfb854" = "0wdpmlcwmqdyyrsmyis8jb7cx3q6fnqpdpc5xly663dj841jcvwh";
    "e12ec26e" = "1y2858n98bfa49syjinx911vza6mm7aa6xalvzjgdlyirhccs30i";
    "1d0db859" = "11s8jciw7xf2668v79qcq2c9w2gwvm3dkcik8dl9v74p654y1nr8";
    "fd084796" = "07l61wvsw1d8g14zzf6zm7l0ri9kkqz8j5n4h116qwhg1p2k49y4";
  };

  makeFlags = "prefix=$(out)";

  meta = with stdenv.lib; {
    homepage = https://www.nongnu.org/dmidecode/;
    description = "A tool that reads information about your system's hardware from the BIOS according to the SMBIOS/DMI standard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
