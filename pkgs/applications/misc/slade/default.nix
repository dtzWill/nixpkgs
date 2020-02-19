{ stdenv, fetchFromGitHub, cmake, pkgconfig, wrapGAppsHook, wxGTK, gtk3, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip, which }:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.1.9";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "17axc37wbysjv6nq9rrs0gsr8nnzp5rib3q9ikjvci9yyxlvwf6a";
  };

  nativeBuildInputs = [ cmake pkgconfig zip which wrapGAppsHook ];
  buildInputs = [ wxGTK gtk3 sfml fluidsynth curl freeimage ftgl glew ];

  cmakeFlags = [ "-DNO_WEBVIEW=1" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = http://slade.mancubus.net/;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
