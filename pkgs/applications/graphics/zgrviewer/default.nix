{ stdenv, fetchurl, jre, unzip, makeWrapper }:
stdenv.mkDerivation rec {
  version = "0.10.0";
  pname = "zgrviewer";
  src = fetchurl {
    url = "mirror://sourceforge/zvtm/${pname}/${version}/${pname}-${version}.zip";
    sha256 = "1cizlrycfgbb1gkfwq14vnihxx5bnsbmwki6p2y4d9bdyfhf4anh";
  };
  nativeBuildInputs = [ unzip makeWrapper ];
  buildInputs = [ jre ];
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out"/{bin,share/java/zvtm/plugins,share/doc/zvtm}

    cp -r target/* "$out/share/java/zvtm/"

    makeWrapper ${jre.home}/bin/java $out/bin/zgrviewer \
    --add-flags "-jar $out/share/java/zvtm/zgrviewer-${version}.jar" \
    --argv0 ${pname} \
    --set JAVA_HOME=${jre.home}
  '';
  meta = {
    # Quicker to unpack locally than load Hydra
    hydraPlatforms = [];
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "GraphViz graph viewer/navigator";
    platforms = with stdenv.lib.platforms; unix;
  };
}
