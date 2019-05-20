{ mkXfceDerivation, exo, dbus-glib, epoxy, gtk2, libXdamage
, libstartup_notification, libxfce4ui, libxfce4util, libwnck
, libXpresent, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "xfwm4";
  version = "4.13.2";

  sha256 = "0kdlkpb7phcrsqhyhnw82f03fzmd5xb4w9fdj94frfprfja0b468";

  nativeBuildInputs = [ exo ];

  buildInputs = [
    dbus-glib
    epoxy
    gtk2
    libXdamage
    libstartup_notification
    libxfce4ui
    libxfce4util
    libwnck
    libXpresent
    xfconf
  ];
}
