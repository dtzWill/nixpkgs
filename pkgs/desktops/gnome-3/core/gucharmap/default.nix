{ stdenv
, intltool
, fetchFromGitLab
, fetchpatch
, pkgconfig
, gtk3
, adwaita-icon-theme
, glib
, desktop-file-utils
, gtk-doc
, meson
, ninja
, wrapGAppsHook
, gnome3
, itstool
, libxml2
, yelp-tools
, docbook_xsl
, docbook_xml_dtd_412
, gsettings-desktop-schemas
, callPackage
, unzip
, gettext
, unicode-character-database
, unihan-database
, runCommand
, symlinkJoin
, gobject-introspection
, vala
}:

let
  # TODO: make upstream patch allowing to use the uncompressed file,
  # preferably from XDG_DATA_DIRS.
  # https://gitlab.gnome.org/GNOME/gucharmap/issues/13
  unihanZip = runCommand "unihan" {} ''
    mkdir -p $out/share/unicode
    ln -s ${unihan-database.src} $out/share/unicode/Unihan.zip
  '';
  ucd = symlinkJoin {
    name = "ucd+unihan";
    paths = [
      unihanZip
      unicode-character-database
    ];
  };
in stdenv.mkDerivation rec {
  pname = "gucharmap";
  version = "13.0.0";

  outputs = [ "out" "lib" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "17arjigs1lw1h428s9g171n0idrpf9ks23sndldsik1zvvwzlldh";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    wrapGAppsHook
    unzip
    intltool
    itstool
    gettext
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_412
    yelp-tools
    libxml2
    desktop-file-utils
    gobject-introspection
    vala
  ];

  buildInputs = [
    gtk3
    glib
    gsettings-desktop-schemas
    adwaita-icon-theme
  ];

  mesonFlags = [
    "-Ducd_path=${ucd}/share/unicode"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs gucharmap/gen-guch-unicode-tables.pl
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME Character Map, based on the Unicode Character Database";
    homepage = "https://wiki.gnome.org/Apps/Gucharmap";
    license = licenses.gpl3;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
