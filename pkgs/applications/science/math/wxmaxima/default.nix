{ stdenv, fetchFromGitHub
, wrapGAppsHook, cmake, gettext
, maxima, wxGTK, gnome3 }:

stdenv.mkDerivation rec {
  pname = "wxmaxima";
  version = "20.01.2";

  src = fetchFromGitHub {
    owner = "wxMaxima-developers";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "0ji6d8cmgfyc42jbbqx8svcswi8235bxv1451f4j7rl5vyyhrswn";
  };

  buildInputs = [ wxGTK maxima gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ wrapGAppsHook cmake gettext ];

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH ":" ${maxima}/bin)
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = licenses.gpl2;
    homepage = https://wxmaxima-developers.github.io/wxmaxima/;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
