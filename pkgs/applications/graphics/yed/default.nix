{ stdenv, fetchzip, wrapGAppsHook, zip, unzip, jre, gtk3, glib, gsettings-desktop-schemas }:

let
  javaFlags = [
    "-Dawt.useSystemAAFontSettings=lcd"
    "-Dsun.java2d.xrender=False"
    #"-Dsun.java2d.opengl=False"
    "-Dswing.aatext=true"
   # "-Dswing.defaultlaf=com.sun.java"
    # New LAF won't be used (apparently) unless the bundled LAF is dropped
    "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
    "-Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
  ];
in
stdenv.mkDerivation rec {
  pname = "yEd";
  version = "3.19.1.1";

  src = fetchzip {
    url = "https://www.yworks.com/resources/yed/demo/${pname}-${version}.zip";
    sha256 = "0px88rc1slf7n1n8lpk56hf29ppbnnd4lrqfyggihcr0pxmw157c";
  };

  nativeBuildInputs = [ wrapGAppsHook zip unzip ];
  buildInputs = [ gtk3 glib gsettings-desktop-schemas ];

  installPhase = ''
    mkdir -p $out/yed
    cp -r * $out/yed
    mkdir -p $out/bin

    zip -d $out/yed/yed.jar com/jgoodies/looks/plastic/Plastic3DLookAndFeel.class

    ln -s ${jre}/bin/java $out/bin/yed

    gappsWrapperArgs+=(--set _JAVA_OPTIONS "${toString javaFlags}")
    gappsWrapperArgs+=(--add-flags "-jar $out/yed/yed.jar --")
  '';

  meta = with stdenv.lib; {
    license = licenses.unfree;
    homepage = http://www.yworks.com/en/products/yfiles/yed/;
    description = "A powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
  };
}
