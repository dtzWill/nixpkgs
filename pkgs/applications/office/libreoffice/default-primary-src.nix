{ fetchurl }:

rec {
  major = "6";
  minor = "3";
  patch = "3";
  tweak = "2";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "1kz5950vhjc33rx7pyl5sw9lxxm90hxrj7v8y86jy34skjrfa3nl";
  };
}
