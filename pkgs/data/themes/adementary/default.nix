{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "adementary-theme";
#  version = "201905r1";
  version = "2019-08-01";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
#    rev    = version;
    rev = "1e7116b8681282142a40b08558a533eb214fa9d6";
    sha256 = "0kwkafz7zd7wprvm9jsj3fxw4x5sp10rvwf0wpf774vdlzjaz1vd";
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
    description = "Adwaita-based gtk+ theme with design influence from elementary OS and Vertex gtk+ theme";
    homepage    = https://github.com/hrdwrrsk/adementary-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms   = platforms.linux;
  };
}
