{ mkDerivation, lib, fetchFromGitHub, cmake, qmake, qtbase, qtwebkit }:

mkDerivation rec {
  pname = "mindforger";
  version = "1.50.0";

  src = fetchFromGitHub {
    owner = "dvorka";
    repo = pname;
    rev = version;
    sha256 = "0s0wav1jq29phcg1zid1bx52h3niiknhmzjramd3wfjmrl7aswj5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qmake ] ;
  buildInputs = [ qtbase qtwebkit ] ;

  doCheck = true;

  enableParallelBuilding = true ;

  patches = [ ./build.patch ] ;

  postPatch = ''
    substituteInPlace deps/discount/version.c.in --subst-var-by TABSTOP 4
    substituteInPlace app/resources/gnome-shell/mindforger.desktop --replace /usr "$out"

    # delete build directory
    rm -rf deps/cmark-gfm/build
  '';

  preConfigure = ''
    pushd deps/cmark-gfm
    mkdir build && cd build
    cmake -DCMARK_TESTS=OFF -DCMARK_SHARED=OFF ..
    cmake --build .
    popd

    export AC_PATH="$PATH"
    pushd deps/discount
    ./configure.sh
    popd
  '';

  dontUseCmakeConfigure = true;
  qmakeFlags = [ "-r mindforger.pro" "CONFIG+=mfnoccache" ] ;

  meta = with lib; {
    description = "Thinking Notebook & Markdown IDE";
    longDescription = ''
     MindForger is actually more than an editor or IDE - it's human
     mind inspired personal knowledge management tool
    '';
    homepage = https://www.mindforger.com;
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
