{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "adementary-theme";
#  version = "201905r1";
  version = "2019-06-19"; # git

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
#    rev    = version;
    rev = "a4ae945";
    sha256 = "1w4kv8xcm2fhssp4dax8qybw9zdhcrs4iq74cqisq48y7jyw3y9q";
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
