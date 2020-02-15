{ mkDerivation, lib, fetchurl, cmake, pkgconfig, extra-cmake-modules
, eigen
, kauth, kconfig, kcrash, kdoctools, kwidgetsaddons, knewstuff, ki18n, kio
, kxmlgui, kplotting, knotifications, knotifyconfig
, qtbase, qtdeclarative, qtsvg, qtwebsockets
, qtkeychain
# TODO: qtdatavisualizations ?

# optionals:
, cfitsio, /* indilib, */ libraw, wcslib

# TODO: runtime: xplanet astronometrynet
}:

mkDerivation rec {
  pname = "kstars";
  version = "3.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0fpami30dv2i5zfnhfsqvrx754a4f1j0sdf6y9ic5734f730vpns";
  };

  nativeBuildInputs = [
    cmake pkgconfig extra-cmake-modules
  ];

  buildInputs = [
    eigen
    cfitsio libraw wcslib
    kauth kconfig kcrash kdoctools kwidgetsaddons knewstuff ki18n kio
    kxmlgui kplotting knotifications knotifyconfig
    qtbase qtdeclarative qtsvg qtwebsockets
    qtkeychain
  ];

  # TODO: glvnd vs "legacy" GL?
}
