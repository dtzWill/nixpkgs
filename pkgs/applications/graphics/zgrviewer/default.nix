{ stdenv, fetchurl, jre, unzip, runtimeShell }:
stdenv.mkDerivation rec {
  version = "0.10.0";
  pname = "zgrviewer";
  name="${pname}-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/zvtm/${pname}/${version}/${name}.zip";
    sha256 = "1cizlrycfgbb1gkfwq14vnihxx5bnsbmwki6p2y4d9bdyfhf4anh";
  };
  buildInputs = [jre unzip];
  buildPhase = "";
  installPhase = ''
    mkdir -p "$out"/{bin,share/java/zvtm/plugins,share/doc/zvtm}

    cp -r target/* "$out/share/java/zvtm/"

    echo '#!${runtimeShell}' > "$out/bin/zgrviewer"
    echo "${jre}/lib/openjdk/jre/bin/java -jar '$out/share/java/zvtm/zgrviewer-${version}.jar' \"\$@\"" >> "$out/bin/zgrviewer"
    chmod a+x "$out/bin/zgrviewer"
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
