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

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      NIX_PLUGINS_DIR = "${placeholder "out"}/lib/qcad/plugins";
      NIX_SHARED_DATA_DIR = "${placeholder "out"}/share/qcad";
    })
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib/qcad,share/qcad,share/man/man1,share/applications}

    # Bin
    install release/qcad-bin $out/bin/qcad

    # Libs
    install -t $out/lib release/*${hostPlatform.extensions.sharedLibrary}

    # Data resources
    cp -vr -t $out/share/qcad \
      examples fonts libraries linetypes patterns scripts themes ts

    # Qt plugins and related
    cp -vr -t $out/lib/qcad \
      plugins platforminputcontexts platforms xcbglintegrations

    # Man
    install qcad.1 -t $out/share/man/man1

    # Desktop file
    install qcad.desktop -t $out/share/applications
  '';

  meta = with lib; {
    description = "2D CAD package based upon Qt";
    homepage = "https://qcad.org";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
