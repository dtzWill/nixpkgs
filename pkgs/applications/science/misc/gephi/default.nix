{ stdenv, fetchFromGitHub, jdk, maven, javaPackages }:

let
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "gephi";
    repo = "gephi";
#    rev = "v${version}";
    rev = "56b8733f03a3aaaa4bcc3ca63744c803f9d7a4c3";
    sha256 = "0w3l7igsfwh6xabwgpsa0q3q9h73pmpcaiwba5ihlqh96vy5p3b7";
  };

  # perform fake build to make a fixed-output derivation out of the files downloaded from maven central (120MB)
  deps = stdenv.mkDerivation {
    name = "gephi-${version}-deps";
    inherit src;
    buildInputs = [ jdk maven ];
    buildPhase = ''
      while mvn package -Dmaven.repo.local=$out/.m2 -Dmaven.wagon.rto=5000; [ $? = 1 ]; do
        echo "timeout, restart maven to continue downloading"
      done
    '';
    # keep only *.{pom,jar,sha1,nbm} and delete all ephemeral files with lastModified timestamps inside
    installPhase = ''find $out/.m2 -type f -regex '.+\(\.lastUpdated\|resolver-status\.properties\|_remote\.repositories\)' -delete'';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "0h9z09bczly5i1s78inmk81xgid9wz24qy4dvg1v19r7icmcnrpg";
  };

  javaFlags = [
    "-Dawt.useSystemAAFontSettings=lcd"
    "-Dsun.java2d.xrender=True"
    #"-Dsun.java2d.opengl=False"
    "-Dswing.aatext=true"
  ];
  # Gather JVM options and prepend each with '-J', with space between each
  javaFlagsString = stdenv.lib.concatMapStringsSep " " (f: "-J${f}") javaFlags;
in
stdenv.mkDerivation rec {
  pname = "gephi";
  version = "2019-01-04";

  inherit src;

  buildInputs = [ jdk maven ];

  buildPhase = ''
    # 'maven.repo.local' must be writable so copy it out of nix store
    mvn package --offline -Dmaven.repo.local=$(cp -dpR ${deps}/.m2 ./ && chmod +w -R .m2 && pwd)/.m2
  '';

  installPhase = ''
    cp -r modules/application/target/gephi $out

    # remove garbage
    find $out -type f -name  .lastModified -delete
    find $out -type f -regex '.+\.exe'     -delete

    # use self-compiled JOGL to avoid patchelf'ing .so inside jars
    rm $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-{jogl,gluegen}/*.jar
    cp ${javaPackages.jogl_2_3_2}/share/java/jogl*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-jogl/
    cp ${javaPackages.jogl_2_3_2}/share/java/glue*.jar $out/gephi/modules/ext/org.gephi.visualization/org-jogamp-gluegen/

    echo "jdkhome=${jdk}" >> $out/etc/gephi.conf
    echo 'default_options+="${javaFlagsString}"' >> $out/etc/gephi.conf
  '';

  meta = with stdenv.lib; {
    description = "A platform for visualizing and manipulating large graphs";
    homepage = https://gephi.org;
    license = licenses.gpl3;
    maintainers = [ maintainers.taeer ];
    platforms = [ "x86_64-linux" ];
  };
}
