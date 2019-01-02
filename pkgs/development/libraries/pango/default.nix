{ stdenv, fetchurl, fetchpatch, pkgconfig, libXft, cairo, harfbuzz
, libintl, gobject-introspection, darwin, fribidi, gnome3
, gtk-doc, docbook_xsl, docbook_xml_dtd_43, makeFontsConf, freefont_ttf
, meson, ninja
}:

with stdenv.lib;

let
  pname = "pango";
  version = "1.43.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1lnxldmv1a12dq5h0dlq5jyzl4w75k76dp8cn360x2ijlm9w5h6j";
  };

  outputs = [ "bin" "dev" "out" "devdoc" ];

  nativeBuildInputs = [ pkgconfig gobject-introspection gtk-doc docbook_xsl docbook_xml_dtd_43 meson ninja ];
  buildInputs = optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Carbon
    CoreGraphics
    CoreText
  ]);
  propagatedBuildInputs = [ cairo harfbuzz libXft libintl fribidi ];

  mesonFlags = [ "-Denable_docs=true" ];

  enableParallelBuilding = true;

  patches = [ (fetchpatch {
    name = "fix-gobject-linking.patch";
    url = https://gitlab.gnome.org/GNOME/pango/commit/d0cb6be7431d1a3c711bd45bcf05b34601604037.patch;
    sha256 = "1cqhy4xbwx3ad7z5d1ks7smf038b9as8c6qy84rml44h0fgiq4m2";
  }) ];

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
