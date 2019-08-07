{ stdenv, fetchurl, fetchFromGitLab, pkgconfig, cairo, harfbuzz
, libintl, gobject-introspection, darwin, fribidi, gnome3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, makeFontsConf, freefont_ttf
, meson, ninja, glib
, freetype, fontconfig
, x11Support? !stdenv.isDarwin, libXft
}:

with stdenv.lib;

let
  pname = "pango";
  version = "1.44.3-git";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  #src = fetchurl {
  #  url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
  #  sha256 = "1kmfwpiqacpfqmmg04218hgvlxivg2pjwcwp7zn2aw2wr80b22r9";
  #};
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "pango";
    rev = "3bca86ac35fb300e2ec5bd24b411f70733952fea";
    sha256 = "00zmjshc4svxqsrbcq2ybyz4dv5ldvbs0fmbib8dvrla5gg9icx2";
  };

  # FIXME: docs fail on darwin
  outputs = [ "bin" "dev" "out" ] ++ optional (!stdenv.isDarwin) "devdoc";

  nativeBuildInputs = [
    meson ninja
    pkgconfig gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_43
  ];
  buildInputs = [
    harfbuzz fribidi
/*    harfbuzz fribidi*/
  ] ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    ApplicationServices
    Carbon
    CoreGraphics
    CoreText
  ]);
  propagatedBuildInputs = [ cairo glib libintl fontconfig freetype harfbuzz fribidi ] ++
    optional x11Support libXft;

  mesonFlags = [
    "-Dgtk_doc=${if stdenv.isDarwin then "false" else "true"}"
    #"-Duse_fontconfig=true"
  ];

  enableParallelBuilding = true;

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  doCheck = false; # /layout/valid-1.markup: FAIL

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  # Requires.private workaround
  #postFixup = ''
  #  find $dev -type f -name "*.pc" -exec sed -i -e 's/^Requires.private/Requires/' '{}' \;
  #'';

  meta = with stdenv.lib; {
    description = "A library for laying out and rendering of text, with an emphasis on internationalization";

    longDescription = ''
      Pango is a library for laying out and rendering of text, with an
      emphasis on internationalization.  Pango can be used anywhere
      that text layout is needed, though most of the work on Pango so
      far has been done in the context of the GTK+ widget toolkit.
      Pango forms the core of text and font handling for GTK+-2.x.
    '';

    homepage = https://www.pango.org/;
    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
