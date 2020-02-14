{ stdenv, fetchurl, lib
, autoPatchelfHook, wrapGAppsHook, dpkg
, electron
}:

stdenv.mkDerivation rec {
  pname = "hyperspace";
  version = "1.1.0-beta3";
  src = fetchurl {
    url = "https://github.com/hyperspacedev/${pname}/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "0zrj7zx8frjjfdykffiw83jdg9dhq6vpqln5cmmpmx9ij5zl3gbq";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -vx $src .
  '';

  installPhase = ''
    mkdir -p $out

    # /usr/share
    mv ./usr/* $out/

    # /opt/Hyperspace\ Desktop
    mkdir -p $out/share/hyperspace
    mv ./opt/Hyperspace\ Desktop/resources/app.asar $out/share/hyperspace/

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/hyperspace \
      --add-flags $out/share/hyperspace/app.asar \
      "''${gappsWrapperArgs[@]}"

    substituteInPlace $out/share/applications/hyperspace.desktop \
     --replace 'Exec="/opt/Hyperspace Desktop/hyperspace"' \
               'Exec="$out/bin/hyperspace"'
  '';

  meta = with lib; {
    description = "A beautiful, fluffy client for the fediverse";
    homepage = "https://hyperspace.marquiskurt.net";
    license = licenses.npl1;
    maintainers = with maintainers; [ dtzWill ];
  };
}
