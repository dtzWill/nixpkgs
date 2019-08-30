{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja, python3
, wrapGAppsHook, vala, shared-mime-info
, cairo, pantheon, glib, gtk3, libxml2, libgee, libarchive
, hicolor-icon-theme # for setup-hook
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.4.1-2019-08-28";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
#    rev = version;
    rev = "729756d62037cf3f6cc6ff0dac866ab3c0aa522a";
    sha256 = "1d7kg6g76vj1ig4pp1nscj4cvdw00ry06cmyddqwa5kqzx1y8432";
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

