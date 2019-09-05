{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "minetime";
  version = "1.6.1";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/marcoancona/MineTime/releases/download/v${version}/${name}.AppImage";
    sha256 = "1ar38wcfzcs4knx2khmja60fa8rnzawm6004wp5gp8kddb831xrw";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = ps: (appimageTools.defaultFhsEnvArgs.multiPkgs ps) ++ [ ps.at-spi2-core ps.at-spi2-atk ];
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "Modern, intuitive and smart calendar application";
    homepage = https://minetime.ai;
    license = licenses.unfree;
    # Should be cross-platform, but for now we just grab the appimage
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dtzWill ];
  };
}
