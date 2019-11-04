{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, pantheon, libgee, gtk3, glib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "luna";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "calo001";
    repo = pname;
    rev = version;
    sha256 = "0jyrw9552a70wqxwzv2swysgi020jczkdl6ynp475a4b0w3dp2y4";
  };

  nativeBuildInputs = [ meson ninja pkgconfig pantheon.vala wrapGAppsHook ];
  buildInputs = [ libgee gtk3 glib pantheon.granite ];

  meta = with stdenv.lib; {
    description = "Calendar Widget for elementary OS";
    homepage = "https://github.com/calo001/luna";
    license = licenses.agpl3;
  };
}
