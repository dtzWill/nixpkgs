{ buildEnv, qtbase }: name: paths:

buildEnv {
  inherit name;
  paths = [ qtbase ] ++ paths;

  pathsToLink = [ "/bin" "/mkspecs" "/include" "/lib" "/share" ];
  extraOutputsToInstall = [ "dev" ];

  postBuild = ''
    rm "$out/bin/qmake"
    cp "${qtbase.dev}/bin/qmake" "$out/bin"
    if [ -L "$out/bin/qt.conf" ]; then
       echo "Removing existing qt.conf symlink"
       rm -vf "$out/bin/qt.conf"
    fi
    cat >"$out/bin/qt.conf" <<EOF
    [Paths]
    Prefix = $out
    Plugins = ${qtbase.qtPluginPrefix}
    Qml2Imports = ${qtbase.qtQmlPrefix}
    Documentation = ${qtbase.qtDocPrefix}
    EOF
  '';
}
