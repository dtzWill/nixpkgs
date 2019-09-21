{ lib
, mkDerivation
, hostPlatform
, fetchFromGitHub
, qmake
, qttools
, qtbase
, qtmultimedia
, qtscript
, qtsvg
, qtxmlpatterns
, libGLU_combined
, qtmacextras
}:

mkDerivation rec {
  pname = "qcad";
  version = "3.23.0.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "16ihpr1j0z28zlmvr18zdnw4ba1wksq5rplmch2ffsk4ihg9d8k1";
  };

  nativeBuildInputs = [ qmake qttools ];
  buildInputs = [
    libGLU_combined
    qtbase
    qtmultimedia
    qtscript
    qtsvg
    qtxmlpatterns
  ]
  ++ lib.optional hostPlatform.isDarwin qtmacextras;

  meta = with lib; {
    description = "2D CAD package based upon Qt";
    homepage = "https://qcad.org";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
