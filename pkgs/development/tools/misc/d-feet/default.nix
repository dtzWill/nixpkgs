{ stdenv, meson, ninja, pkgconfig, fetchurl, itstool, intltool, libxml2, glib, gtk3
, python3Packages, wrapGAppsHook, gnome3, libwnck3, gobject-introspection }:

let
  pname = "d-feet";
  version = "0.3.15";
in python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/d-feet/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1cgxgpj546jgpyns6z9nkm5k48lid8s36mvzj8ydkjqws2d19zqz";
  };

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [ meson ninja pkgconfig itstool intltool wrapGAppsHook libxml2 glib.dev ]
    ++ (with python3Packages; [ pep8 pycodestyle ]);
  buildInputs = [ glib gtk3 gnome3.adwaita-icon-theme libwnck3 gobject-introspection ];

  propagatedBuildInputs = with python3Packages; [ pygobject3 pep8 ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "dfeet";
      versionPolicy = "none";
    };
  };

  meta = {
    description = "D-Feet is an easy to use D-Bus debugger";

    longDescription = ''
      D-Feet can be used to inspect D-Bus interfaces of running programs
      and invoke methods on those interfaces.
    '';

    homepage = https://wiki.gnome.org/Apps/DFeet;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ktosiek ];
  };
}
