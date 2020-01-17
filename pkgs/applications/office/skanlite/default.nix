{ lib, mkDerivation, fetchurl, cmake, extra-cmake-modules, qtbase,
  kcoreaddons, kdoctools, ki18n, kio, kxmlgui, ktextwidgets,
  libksane
}:

mkDerivation rec {
  pname = "skanlite";
  version = "2.1.0.1";

  src = fetchurl {
    url    = "mirror://kde/stable/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hh4wwlbdi708wf4r6gc5xfajrgxgg21xa1aa94zgsh6nxakwwxl";
  };

  nativeBuildInputs = [ cmake kdoctools extra-cmake-modules ];

  buildInputs = [
    qtbase
    kcoreaddons kdoctools ki18n kio kxmlgui ktextwidgets
    libksane
  ];

  meta = with lib; {
    description = "KDE simple image scanning application";
    homepage    = http://www.kde.org/applications/graphics/skanlite/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pshendry ];
    platforms   = platforms.linux;
  };
}
