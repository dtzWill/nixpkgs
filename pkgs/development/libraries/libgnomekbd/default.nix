{ stdenv, fetchurl, pkgconfig, file, intltool, glib, gtk3, libxklavier, makeWrapper, gobject-introspection, gnome3 }:

stdenv.mkDerivation rec {
  pname = "libgnomekbd";
  version = "3.26.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0y962ykn3rr9gylj0pwpww7bi20lmhvsw6qvxs5bisbn2mih5jpp";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = pname; };
  };

  nativeBuildInputs = [ pkgconfig file intltool makeWrapper ];
  buildInputs = [ glib gtk3 gobject-introspection ];
  propagatedBuildInputs = [ libxklavier ];

  preFixup = ''
    wrapProgram $out/bin/gkbd-keyboard-display \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Keyboard management library";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
