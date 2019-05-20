{ mkXfceDerivation, exo, gtk3, libgudev, libxfce4ui, libxfce4util, xfconf }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "thunar-volman";
  version = "0.9.2";

  buildInputs = [ exo gtk3 libgudev libxfce4ui libxfce4util xfconf ];

  sha256 = "1g784yjhjacjnkhr8m62xyhnxlfbwk0fwb366p9kkz035k51idrv";
}
