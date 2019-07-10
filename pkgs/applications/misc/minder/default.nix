{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja, python3
, wrapGAppsHook, vala, shared-mime-info
, cairo, pantheon, glib, gtk3, libxml2, libgee, libarchive
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.3.1-git";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    #rev = version;
    rev = "b1b7328cf2cd228726de2a3a6bfeb210e9230b61";
    sha256 = "03ivg5kh13vl54cm2m2k4aav9346l6ynrqan4wzzjwshrik1p66h";
  };

  nativeBuildInputs = [ pkgconfig meson ninja python3 wrapGAppsHook vala shared-mime-info ];
  buildInputs = [ cairo pantheon.granite glib gtk3 libxml2 libgee libarchive ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping application for Elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}

