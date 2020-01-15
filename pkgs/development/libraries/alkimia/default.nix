{ mkDerivation, fetchurl, lib
, extra-cmake-modules, doxygen, graphviz, qtbase, qtwebkit, mpir
, kdelibs4support, plasma-framework, knewstuff, kpackage
}:

mkDerivation rec {
  pname = "alkimia";
  version = "8.0.3";

  src = fetchurl {
    url = "mirror://kde/stable/alkimia/${version}/${pname}-${version}.tar.xz";
    sha256 = "0gmkqycgqfx65m8dhnlz5s44xzwdn20nlmg7flsqwzamg69fsmqy";
  };

  nativeBuildInputs = [ extra-cmake-modules doxygen graphviz ];

  buildInputs = [ qtbase qtwebkit kdelibs4support plasma-framework knewstuff kpackage ];
  propagatedBuildInputs = [ mpir ];

  meta = {
    description = "Library used by KDE finance applications";
    longDescription = ''
      Alkimia is the infrastructure for common storage and business
      logic that will be used by all financial applications in KDE.

      The target is to share financial related information over
      application bounderies.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = qtbase.meta.platforms;
  };
}
