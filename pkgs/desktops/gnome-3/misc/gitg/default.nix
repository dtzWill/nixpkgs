{ stdenv, fetchurl, vala, intltool, pkgconfig, gtk3, glib
, json-glib, wrapGAppsHook, libpeas, bash, gobjectIntrospection
, gnome3, gtkspell3, shared-mime-info, libgee, libgit2-glib, libsecret
 }:

let
  pname = "gitg";
  version = "3.30.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "15qaaz4072lxs16nqr5b65xjyrjqy6ch5bmy1rb288fnzf3aw457";
  };

  preCheck = ''
    substituteInPlace tests/libgitg/test-commit.c --replace "/bin/bash" "${bash}/bin/bash"
  '';
  doCheck = true;

  enableParallelBuilding = true;

  makeFlags = "INTROSPECTION_GIRDIR=$(out)/share/gir-1.0/ INTROSPECTION_TYPELIBDIR=$(out)/lib/girepository-1.0";

  buildInputs = [
    gtk3 glib json-glib libgee libpeas gnome3.libsoup
    libgit2-glib gtkspell3 gnome3.gtksourceview gnome3.gsettings-desktop-schemas
    libsecret gobjectIntrospection gnome3.adwaita-icon-theme
  ];

  nativeBuildInputs = [ vala wrapGAppsHook intltool pkgconfig ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
