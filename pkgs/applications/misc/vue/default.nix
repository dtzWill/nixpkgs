{ stdenv, fetchurl, jre, runtimeShell }:

let
  javaFlags = [
    "-Dawt.useSystemAAFontSettings=lcd"
    "-Dsun.java2d.xrender=True"
    #"-Dsun.java2d.opengl=False"
    "-Dswing.aatext=true"
   # "-Dswing.defaultlaf=com.sun.java"
    "-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
    "-Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
  ];
in
stdenv.mkDerivation rec {
  name = "vue-${version}";
  version = "3.3.0";
  src = fetchurl {
    url = "http://releases.atech.tufts.edu/jenkins/job/VUE/116/deployedArtifacts/download/artifact.1";
    sha256 = "0yfzr80pw632lkayg4qfmwzrqk02y30yz8br7isyhmgkswyp5rnx";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -p "$out"/{share/vue,bin}
    cp ${src} "$out/share/vue/vue.jar"
    cat > $out/bin/vue <<EOF
    #!${runtimeShell}
    _JAVA_OPTIONS="${toString javaFlags}" \
    ${jre}/bin/java -jar "$out/share/vue/vue.jar" "$@"
    EOF
    chmod a+x "$out/bin/vue"
  '';

  meta = {
    description = "Visual Understanding Environment - mind mapping software";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.free; # Apache License fork, actually
  };
}
