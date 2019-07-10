{ lib, buildPythonApplication, fetchFromGitHub
, gdk_pixbuf, glib, gobject-introspection, gtk3, gtksourceview, pango, webkitgtk
, pygobject3, pyyaml
}:

buildPythonApplication rec {
  pname = "rednotebook";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "jendrikseipp";
    repo = "rednotebook";
    rev = "v${version}";
    sha256 = "04c7a0wgmdl88v9386y1052c38ajbkryiwhqps5lx34d4g7r6hm1";
  };

  # We have not packaged tests.
  doCheck = false;

  nativeBuildInputs = [ gobject-introspection ];

  propagatedBuildInputs = [
    gdk_pixbuf glib gtk3 gtksourceview pango webkitgtk
    pygobject3 pyyaml
  ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  meta = with lib; {
    homepage = http://rednotebook.sourceforge.net/;
    description = "A modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej tstrobel ];
  };
}
