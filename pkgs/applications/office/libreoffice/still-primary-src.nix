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
    sha256 = "0s9s6nhp2whwxis54jbxrf1dwpnpl95b9781d1pdj4xk5z9v90fv";
  };
}
