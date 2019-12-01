{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "staruml";
  version = "3.1.1";
in appimageTools.wrapType2 rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://staruml.io/download/releases/StarUML-${version}.AppImage";
    sha256 = "0p2h9qi0asqgjn3fxkyhn8d3bhd7np5pz5yi5dxb7kp6isv1gwgz";
  };

  profile = ''
    export LC_ALL=C.UTF-8
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  meta = with lib; {
    description = "A sophisticated software modeler";
    homepage = http://staruml.io/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
