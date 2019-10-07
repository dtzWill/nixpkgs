{ stdenv, fetchFromGitHub, cmake, pkgconfig, wxGTK, gtk3, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip, which }:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "1yfq7ghg9whys7a07xfcza8rwyfhnrcz6qi5bay1ilj3ml4m12zy";
  };

  nativeBuildInputs = [ cmake pkgconfig zip which ];
  buildInputs = [ wxGTK gtk3 sfml fluidsynth curl freeimage ftgl glew ];

  patches = [ 
    ./0001-Use-wxWidgets_CONFIG_EXECUTABLE-in-cmake-when-it-is-.patch
  ];
  patchFlags = [ "-p0" ];

  postPatch = ''
    sed -i -e '32imessage("-- wxWidgets version is: ''${WX_VERSION}")' src/CMakeLists.txt
  '';

  cmakeFlags = [
    "-DwxWidgets_CONFIG_EXECUTABLE=${wxGTK}/bin/wx-config"
    "-DCL_WX_CONFIG=wx-config"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = http://slade.mancubus.net/;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
