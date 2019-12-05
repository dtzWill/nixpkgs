{ stdenv, fetchFromGitHub, qmake4Hook , qt4, libX11, libXext }:

stdenv.mkDerivation rec {
  pname = "qtstyleplugin-kvantum-qt4";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "Kvantum";
    #rev = "f1674c455fa718dc8a9cf00fffb3269aa3f20d7a";
    rev = "V${version}";
    sha256 = "09lidmxacwza15zg858z05pz27n0asd18qhmpb591ak410vd530q";
  };

  nativeBuildInputs = [ qmake4Hook ];
  buildInputs = [ qt4 libX11 libXext ];

  sourceRoot = "source/Kvantum";

  buildPhase = ''
    qmake kvantum.pro
    make
  '';

  installPhase = ''
    mkdir $TMP/kvantum
    make INSTALL_ROOT="$TMP/kvantum" install
    mv $TMP/kvantum/usr/ $out
    mv $TMP/kvantum/${qt4}/lib $out
  '';

  meta = with stdenv.lib; {
    description = "SVG-based Qt4 theme engine";
    homepage = "https://github.com/tsujan/Kvantum";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bugworm ];
  };
}
