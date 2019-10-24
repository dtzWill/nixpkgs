{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja, python3
, wrapGAppsHook, vala, shared-mime-info
, cairo, pantheon, glib, gtk3, libxml2, libgee, libarchive
, hicolor-icon-theme # for setup-hook
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.5.0-git";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    #rev = version;
    rev = "bb5edfdb21818e7dc2b37b627eb69ddc64a1a056";
    sha256 = "0n9ciazgl03hd6gicvnf2jgl0vv87hm8h8jl4wlbf662lfmd3kks";
  };

  nativeBuildInputs = [ pkgconfig meson ninja python3 wrapGAppsHook vala shared-mime-info ];
  buildInputs = [ cairo pantheon.granite glib gtk3 libxml2 libgee libarchive hicolor-icon-theme ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  postFixup = ''
    for x in $out/bin/*; do
      ln -vrs $x "$out/bin/''${x##*.}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping application for Elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}

