{ fetchurl }:

rec {
  major = "6";
  minor = "1";
  patch = "1";
  tweak = "1";

  subdir = "${major}.${minor}.${patch}";

  version = "${subdir}${if tweak == "" then "" else "."}${tweak}";

  src = fetchurl {
    url = "https://download.documentfoundation.org/libreoffice/src/${subdir}/libreoffice-${version}.tar.xz";
    sha256 = "16h60j7h9z49vfhhj22m64myksnrrgrnh0qc6i4bxgshmm8kkzdn";
  };
}
