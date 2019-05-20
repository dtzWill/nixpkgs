{ lib, mkXfceDerivation, exo, gtk2, gtk3 ? null, libwnck3 ? null, libXmu }:

let
  inherit (lib) enableFeature;
in

mkXfceDerivation rec {
  category = "apps";
  pname = "xfce4-taskmanager";
  version = "1.2.2";

  sha256 = "03js0pmhrybxa7hrp3gx4rm7j061ansv0bp2dwhnbrdpmzjysysc";

  nativeBuildInputs = [ exo ];
  buildInputs = [ gtk2 gtk3 libwnck3 libXmu ];

  configureFlags = [ (enableFeature (gtk3 != null) "gtk3") ];
}
