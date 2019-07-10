{ stdenv, fetchurl, jre, makeWrapper
, ncurses, libXxf86vm }:

let
  path = stdenv.lib.makeBinPath [ ncurses.dev /* infocomp */ ];
  libpath = stdenv.lib.makeLibraryPath [ libXxf86vm ];
in
stdenv.mkDerivation rec {
  name = "cytoscape-${version}";
  version = "3.7.1";

  src = fetchurl {
    url = "https://github.com/cytoscape/cytoscape/releases/download/${version}/${name}.tar.gz";
    sha256 = "1mhsngbwbgdwl70wj7850zg94534lasihwv2ryifardm35mkh48k";
  };

  buildInputs = [jre makeWrapper];

  installPhase = ''
    mkdir -pv $out/{share,bin}
    cp -Rv * $out/share/

    ln -s $out/share/cytoscape.sh $out/bin/cytoscape

    wrapProgram $out/share/cytoscape.sh \
      --set JAVA_HOME "${jre}" \
      --set JAVA  "${jre}/bin/java" \
      --prefix PATH : ${path} \
      --prefix LD_LIBRARY_PATH : ${libpath}

    chmod +x $out/bin/cytoscape
  '';

  meta = {
    homepage = http://www.cytoscape.org;
    description = "A general platform for complex network analysis and visualization";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [stdenv.lib.maintainers.mimadrid];
    platforms = stdenv.lib.platforms.unix;
  };
}
