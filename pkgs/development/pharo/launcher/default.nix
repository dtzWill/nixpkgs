{ stdenv, fetchurl, bash, pharo, unzip, makeDesktopItem }:

stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "pharo-launcher-${version}";
  src = fetchurl {
    url = "http://files.pharo.org/pharo-launcher/${version}/PharoLauncher-linux-${version}-x64.zip";
    sha256 = "0ng9hyz8bqc892hslsvli506ywfmv5ky3fvq4ysszbgh0kfr5qwq";
  };

  executable-name = "pharo-launcher";

  desktopItem = makeDesktopItem {
    name = "Pharo";
    exec = "${executable-name}";
    icon = "pharo";
    comment = "Launcher for Pharo distributions";
    desktopName = "Pharo";
    genericName = "Pharo";
    categories = "Development;";
  };

  # because upstream tarball has no top-level directory.
  sourceRoot = ".";

  buildInputs = [ bash pharo unzip ];

  installPhase = ''
    mkdir -p $prefix/share/pharo-launcher
    mkdir -p $prefix/bin

    mv PharoLauncher.image $prefix/share/pharo-launcher/pharo-launcher.image
    mv PharoLauncher.changes $prefix/share/pharo-launcher/pharo-launcher.changes

    mkdir -p $prefix/share/applications
    cp "${desktopItem}/share/applications/"* $out/share/applications

    cat > $prefix/bin/${executable-name} <<EOF
    #!${bash}/bin/bash
    exec "${pharo}/bin/pharo" $prefix/share/pharo-launcher/pharo-launcher.image
    EOF
    chmod +x $prefix/bin/${executable-name}
  '';

  doCheck = true;

  checkPhase = ''
    # Launcher should be able to run for a few seconds without crashing.
    (set +e
     export HOME=. # Pharo will try to create files here
     secs=5
     echo -n "Running headless Pharo for $secs seconds to check for a crash... "
     timeout $secs \
       "${pharo}/bin/pharo" --nodisplay PharoLauncher.image --no-quit eval 'true'
     test "$?" == 124 && echo "ok")
  '';

  meta = {
    description = "Launcher for Pharo distributions";
    longDescription = ''

      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small
      core system, excellent dev tools, and maintained releases, Pharo
      is an attractive platform to build and deploy mission critical
      applications.

      The Pharo Launcher is a cross-platform application that
        - lets you manage your Pharo images (launch, rename, copy and delete);
        - lets you download image templates (i.e., zip archives) from many
          different sources (e.g., Jenkins, files.pharo.org);
        - lets you create new images from any template.

      The idea behind the Pharo Launcher is that you should be able to
      access it very rapidly from your OS application launcher. As a
      result, launching any image is never more than 3 clicks away.
    '';
    homepage = http://pharo.org;
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    platforms = pharo.meta.platforms;
  };
}
