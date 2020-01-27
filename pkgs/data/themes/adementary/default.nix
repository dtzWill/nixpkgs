{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "adementary-theme";
#  version = "201905r1";
  version = "unstable-2020-01-12";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
#    rev    = version;
    rev = "ddf05da5f13fcc4e2e538e8805a501efcd58a545";
    sha256 = "1qfrq48j1z0a4v0qcvhpi7cx05pxcsacwfr3w7r4lib11rix1px8";
  };

  preBuild = ''
    # Shut up inkscape's warnings
    export HOME="$NIX_BUILD_ROOT"
  '';

  nativeBuildInputs = [ sassc ];
  buildInputs = [ gtk3 ];

  postPatch = "patchShebangs .";

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "Adwaita-based GTK theme with design influence from elementary OS and Vertex GTK theme";
    homepage    = https://github.com/hrdwrrsk/adementary-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms   = platforms.linux;
  };
}
