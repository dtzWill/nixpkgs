{ lib, mkXfceDerivation, gobject-introspection, gtk2, gtk3, libICE, libSM
, libstartup_notification, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "libxfce4ui";
  version = "4.15.1";

  sha256 = "049czx984llqplk9jqj9nqxi9mnl8pqfwp8c22pdh6257mafpzyk";

  nativeBuildInputs = [ gobject-introspection ];
  buildInputs =  [ gtk2 gtk3 libstartup_notification xfconf ];
  propagatedBuildInputs = [ libxfce4util libICE libSM ];

  configureFlags = [
    "--with-vendor-info='NixOS'"
  ];

  meta = with lib; {
    description = "Widgets library for Xfce";
    license = licenses.lgpl2Plus;
  };
}
