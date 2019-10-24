{ stdenv, fetchurl, lib
, autoPatchelfHook, wrapGAppsHook, dpkg
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
  version = "1.0.0";
  src = fetchurl {
    url = "https://github.com/hyperspacedev/${pname}/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "09j54jjajsdwrc38xm00ydf5k4i3a7ib1pdzswb0lx68h89cdcaj";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    #wrapGAppsHook
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -vx $src .
  '';

  installPhase = ''
    mkdir -p $out

    # /usr/share
    mv ./usr/* $out/

    # /opt/Hyperspace
    mv ./opt/Hyperspace $out/share/hyperspace

    mkdir -p $out/bin
    ln -s $out/share/hyperspace/hyperspace $out/bin/hyperspace

    rm -vrf $out/share/hyperspace/{libGLESv2.so,libEGL.so,swiftshader}

    substituteInPlace $out/share/applications/hyperspace.desktop \
     --replace "Exec=/opt/Hyperspace/hyperspace" \
               "Exec=$out/bin/hyperspace"
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
    homepage = "https://hyperspace.marquiskurt.net";
    # license = # XXX: "non-violent" ?!
    maintainers = with maintainers; [ dtzWill ];
  };
}
