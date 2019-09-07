{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, qttools,
  qtbase, qtsvg,
}:

mkDerivation rec {
  pname = "kdiagram";
  version = "2.6.1";
  src = fetchurl {
    url = "https://download.kde.org/stable/kdiagram/${version}/${pname}-${version}.tar.xz";
    sha256 = "1c6dbp9gssjrx59z8yxzq1ay56pnw7h28symjrv0gcvhxyjirrxx";
  };
  nativeBuildInputs = [ extra-cmake-modules qttools ];
  propagatedBuildInputs = [ qtbase qtsvg ];
  meta = {
    description = "Libraries for creating business diagrams";
    license = lib.licenses.gpl2;
    platforms = qtbase.meta.platforms;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
