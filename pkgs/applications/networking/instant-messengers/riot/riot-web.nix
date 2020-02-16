{ lib, stdenv, fetchurl, writeText, conf ? null }:

# Note for maintainers:
# Versions of `riot-web` and `riot-desktop` should be kept in sync.

stdenv.mkDerivation rec {
  pname = "riot-web";
  version = "1.5.9-rc.1";

  src = fetchurl {
    url = "https://github.com/vector-im/riot-web/releases/download/v${version}/riot-v${version}.tar.gz";
    sha256 = "02dnw5g2h9q7mfkr1x3aimz7zkhblgapi40chqrj1zvd2869ln9j";
  };

  installPhase = let
    configFile = if (conf != null)
      then writeText "riot-config.json" conf
      else "$out/config.sample.json";
  in ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/
    ln -s ${configFile} $out/config.json

    runHook postInstall
  '';

  meta = {
    description = "A glossy Matrix collaboration client for the web";
    homepage = http://riot.im/;
    maintainers = with stdenv.lib.maintainers; [ bachp pacien ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    hydraPlatforms = [];
  };
}
