{
  mkDerivation, lib, extra-cmake-modules, kdoctools, shared-mime-info,
  exiv2, kactivities, karchive, kbookmarks, kconfig, kconfigwidgets,
  kcoreaddons, kdbusaddons, kguiaddons, kdnssd, kiconthemes, ki18n, kio, khtml,
  kdelibs4support, kpty, syntax-highlighting, libmtp, libssh, openexr, ilmbase,
  openslp, phonon, qtsvg, samba, solid, gperf,
  fetchpatch
}:

mkDerivation {
  name = "kio-extras";
  meta = {
    license = with lib.licenses; [ gpl2 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  nativeBuildInputs = [ extra-cmake-modules kdoctools shared-mime-info ];
  buildInputs = [
    exiv2 kactivities karchive kbookmarks kconfig kconfigwidgets kcoreaddons
    kdbusaddons kguiaddons kdnssd kiconthemes ki18n kio khtml kdelibs4support
    kpty syntax-highlighting libmtp libssh openexr openslp phonon qtsvg samba
    solid gperf
  ];
  CXXFLAGS = [ "-I${ilmbase.dev}/include/OpenEXR" ];

  patches = [
    (fetchpatch {
      name = "fix-for-libssh-0.9.22.patch";
      url = "https://cgit.kde.org/kio-extras.git/patch/?id=24506c2af8d1904a99538543804306c6c2b81ca2";
      sha256 = "0djirdkxkg6n2v7lbb0fv3zng03b2cx9gwg2h4av3y2jvbv0rn1r";
    })
  ];
}
