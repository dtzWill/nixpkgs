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
  version = "1.0.4";
  src = fetchurl {
    url = "https://github.com/hyperspacedev/${pname}/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "04ff3xqv9dbm0mrsil2yxfsmvmpdfggdnazks9v2z34wll8wsdbk";
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

    # /opt/Hyperspace\ Desktop
    mv ./opt/Hyperspace\ Desktop $out/share/hyperspace

    mkdir -p $out/bin
    ln -s $out/share/hyperspace/hyperspace $out/bin/hyperspace

    rm -vrf $out/share/hyperspace/{libGLESv2.so,libEGL.so,swiftshader}

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
