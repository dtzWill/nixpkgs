{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "6";
  tweak = "3";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1h9c6kb8qr9zd9qjjj3xmw72haj4i0qvdx0l1wd2ppzvr08fyb3d";
  };
}
