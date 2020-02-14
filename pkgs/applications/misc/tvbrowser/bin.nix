{ stdenv, fetchurl, makeWrapper, jdk12, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "tvbrowser";
    exec = "tvbrowser";
    icon = "tvbrowser";
    comment = "Themeable and easy to use TV Guide";
    desktopName = "TV-Browser";
    genericName = "Electronic TV Program Guide";
    categories = "AudioVideo;TV;Java;";
    startupNotify = "true";
    extraEntries = ''
      StartupWMClass=tvbrowser-TVBrowser
    '';
  };

in stdenv.mkDerivation rec {
  pname = "tvbrowser";
  version = "4.2.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/TV-Browser%20Releases%20%28Java%2011%20and%20higher%29/${version}/${pname}_${version}_bin.tar.gz";
    sha256 = "1zbl6nw7ia69ik4mkfkr3ka46rb1qh8v0dq64bww14w6dhqbr661";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/java/${pname}
    cp -R * $out/share/java/${pname}
    rm $out/share/java/${pname}/${pname}.{sh,desktop}

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    for i in 16 32 48 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps
      ln -s $out/share/java/${pname}/imgs/${pname}$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/${pname}.png
    done

    mkdir -p $out/bin
    makeWrapper ${jdk12}/bin/java $out/bin/${pname} \
      --add-flags '--module-path "lib:tvbrowser.jar"' \
      --add-flags "-Djava.library.path=$out/share/java/${pname}" \
      --add-flags "-splash:imgs/splash.png" \
      --add-flags "-Dpropertiesfile=linux.properties" \
      --add-flags "-m tvbrowser/tvbrowser.TVBrowser" \
      --run "cd $out/share/java/${pname}" \
  '';

  meta = with stdenv.lib; {
    description = "Electronic TV Program Guide";
    homepage = https://www.tvbrowser.org/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
