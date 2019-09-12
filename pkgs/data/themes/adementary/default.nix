{ stdenv, fetchFromGitHub, gtk3, sassc }:

stdenv.mkDerivation rec {
  pname = "adementary-theme";
#  version = "201905r1";
  version = "2019-09-12";

  src = fetchFromGitHub {
    owner  = "hrdwrrsk";
    repo   = pname;
#    rev    = version;
    rev = "2df8291612ba4993d2b0e9682c9f31f7b4ac9464";
    sha256 = "0x5xp38vpriry46vwislrpb1nfq2rxlng66ijrg6m8raqpq7kl48";
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
