{ stdenv, lib, fetchurl, extra-cmake-modules
, qtbase, qca-qt5, kdeFrameworks
, smartmontools, parted
, utillinux }:

let
  pname = "kpmcore";
  # kpmcore needs 2.32.2 and presently our version is 2.32.1,
  # so override it locally until we've updated it system-wide.
  utillinuxNewer = utillinux.overrideAttrs(o: rec {
    name = "util-linux-${version}";
    version = "2.33.2";
    src = fetchurl {
      url = "mirror://kernel/linux/utils/util-linux/v2.33/util-linux-2.33.2.tar.xz";
      sha256 = "15yf2dh4jd1kg6066hydlgdhhs2j3na13qld8yx30qngqvmfh6v3";
    };
  });

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "4.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/src/${name}.tar.xz";
    sha256 = "0vfz9pr9n6p9hs3d9cm8yirp9mkw76nhnin55v3bwsb34p549w6p";
  };

  buildInputs = [
    qtbase qca-qt5
    smartmontools
    parted # we only need the library

    kdeFrameworks.kauth
    kdeFrameworks.kio

    utillinuxNewer # needs blkid (note that this is not provided by utillinux-compat)
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    maintainers = with lib.maintainers; [ peterhoeg ];
    # The build requires at least Qt 5.12:
    broken = lib.versionOlder qtbase.version "5.12.0";
  };
}
