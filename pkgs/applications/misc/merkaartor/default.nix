{ mkDerivation, lib, fetchFromGitHub, makeWrapper, qmake, pkgconfig, boost, gdal, proj
, qtbase, qtsvg, qtwebkit }:

mkDerivation rec {
  pname = "merkaartor";
  version = "0.18.4";

  src = fetchFromGitHub {
    owner = "openstreetmap";
    repo = pname;
    rev = version;
    sha256 = "0h3d3srzl06p2ajq911j05zr4vkl88qij18plydx45yqmvyvh0xz";
  };

  nativeBuildInputs = [ makeWrapper qmake pkgconfig ];

  buildInputs = [ boost gdal proj qtbase qtsvg qtwebkit ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H" ];

  meta = with lib; {
    description = "OpenStreetMap editor";
    homepage = http://merkaartor.be/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
