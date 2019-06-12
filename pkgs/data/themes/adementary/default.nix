{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "adementary-theme";
#  version = "201905r1";
  version = "2019-06-10"; # git

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
#    rev    = version;
    rev = "884ef9b79d417ca2f8e32234eb70b5d7da5f15c7";
    sha256 = "1qmcjc6lbq3vafs5iil0r13rd0xvpc52xc8zi0cwsmck2mawdqsf";
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
