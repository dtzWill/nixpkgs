{ fetchurl }:

rec {
  major = "6";
  minor = "0";
  patch = "6";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "13kaikaz65xw9a3hxbh245cnydjpy58np22c7s0s65pnmcq68rpi";
  };
}
