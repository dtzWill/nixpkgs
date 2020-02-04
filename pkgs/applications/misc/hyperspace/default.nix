{ stdenv, fetchurl, lib
, autoPatchelfHook, wrapGAppsHook, dpkg
, electron_7
, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst, libXaw, fontconfig, pango, cairo, glib, libxml2, atk, gtk3
, gdk-pixbuf
# more
, nss, nspr
, libXScrnSaver
, alsaLib
# rt?
, udev, libGL
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
    makeWrapper ${electron_7}/bin/electron $out/bin/hyperspace \
      --add-flags $out/share/hyperspace/app.asar \
      "''${gappsWrapperArgs[@]}"

    substituteInPlace $out/share/applications/hyperspace.desktop \
     --replace 'Exec="/opt/Hyperspace Desktop/hyperspace"' \
               'Exec="$out/bin/hyperspace"'
  '';

  buildInputs = [
    # From maxx, only w/gtk3
    stdenv.cc.cc libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst libXaw fontconfig pango cairo glib libxml2 atk gtk3
    gdk-pixbuf
    # more
    nss nspr
    libXScrnSaver
    alsaLib
  ];

  runtimeDependencies = [ libGL udev.lib ];

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "A beautiful, fluffy client for the fediverse";
    homepage = "https://hyperspace.marquiskurt.net";
    license = licenses.npl1;
    maintainers = with maintainers; [ dtzWill ];
  };
}
