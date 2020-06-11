{stdenv, fetchurl, runtimeShell, traceDeps ? false}:

let
  traceLog = "/tmp/steam-trace-dependencies.log";
  version = "1.0.0.62";

in stdenv.mkDerivation {
  pname = "steam-original";
  inherit version;

  src = fetchurl {
    url = "http://repo.steampowered.com/steam/pool/steam/s/steam/steam_${version}.tar.gz";
    sha256 = "1pw8ypsiv1wirn5mwh4b1s6v7yg5gdi1pysiwqaq3vxkg5rzzjw3";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    rm $out/bin/steamdeps
    ${stdenv.lib.optionalString traceDeps ''
      cat > $out/bin/steamdeps <<EOF
      #!${runtimeShell}
      echo \$1 >> ${traceLog}
      cat \$1 >> ${traceLog}
      echo >> ${traceLog}
      EOF
      chmod +x $out/bin/steamdeps
    ''}
    install -d $out/lib/udev/rules.d
    install -m644 subprojects/steam-devices/*.rules $out/lib/udev/rules.d
  '';

  meta = with stdenv.lib; {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ jagajaga ];
  };
}
