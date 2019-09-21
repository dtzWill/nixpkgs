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

  postPatch = ''
    substituteInPlace src/core/RS.cpp \
      --replace /usr/share $out/share
  '';

  # TODO:
  # * put in $out/share/qcad instead
  #   * patch up resource code
  # * put qcad-bin in $out/libexec
  # * put libs into $out/lib, ensure they're found (maybe fixup rpath)
  # * qt bits into $out/lib ..?
  installPhase = ''
    mkdir -p $out/{bin,lib,share/man/man1}
    install -t $out/lib release/qcad-bin
    ln -rsv $out/lib/qcad-bin $out/bin/qcad

    install -t $out/lib \
      release/lib{spatialindexnavel,qcad}*${hostPlatform.extensions.sharedLibrary}

    install qcad.1 -t $out/share/man/man1

    # Data resources
    cp -vr -t $out/lib \
      examples fonts libraries linetypes patterns scripts themes ts
    # Qt
    cp -vr -t $out/lib \
      plugins platforminputcontexts platforms xcbglintegrations
  '';

  # qt wrapper doesn't process symlinks presently (temporary regression),
  # so handle this explicitly ourselves:
  preFixup = ''
    echo "Replacing symlink with wrapper..."
    rm -v $out/bin/qcad
    makeQtWrapper $out/lib/qcad-bin $out/bin/qcad
  '';

  meta = with lib; {
    description = "2D CAD package based upon Qt";
    homepage = "https://qcad.org";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
