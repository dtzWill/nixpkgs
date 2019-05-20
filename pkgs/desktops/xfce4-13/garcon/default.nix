{ mkXfceDerivation, gtk2 ? null, gtk3, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "garcon";
  version = "0.6.2";

  sha256 = "0gmvi6m3iww7m3xxx5wiqd8vsi18igzhcpjfzknfc8z741vc38yj";

  buildInputs = [ gtk2 gtk3 libxfce4ui libxfce4util ];
}
