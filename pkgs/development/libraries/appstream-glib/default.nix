{ stdenv
, fetchFromGitHub
, substituteAll
, docbook_xml_dtd_42
, docbook_xsl
, fontconfig
, freetype
, gdk-pixbuf
, gettext
, glib
, gobject-introspection
, gperf
, gtk-doc
, gtk3
, json-glib
, libarchive
, libsoup
, libuuid
, libxslt
, meson
, ninja
, pkgconfig
, pngquant
, libyaml
, libstemmer
}:
stdenv.mkDerivation rec {
  pname = "appstream-glib";
  version = "0.7.17";

  outputs = [ "out" "dev" "man" "installedTests" ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = pname;
    rev = stdenv.lib.replaceStrings [ "." "-" ] [ "_" "_" ] "${pname}-${version}";
    sha256 = "06pm8l58y0ladimyckbvlslr5bjj9rwb70rgjmn09l41pdpipy2i";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_42
    docbook_xsl
    gettext
    gobject-introspection
    gperf
    gtk-doc
    libxslt
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    ## attr
    ## acl
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    json-glib
    libarchive
    libsoup
    libuuid

    libyaml
    libstemmer
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      pngquant = "${pngquant}/bin/pngquant";
    })
  ];

  mesonFlags = [
    "-Drpm=false"
    "-Dstemmer=true"
    "-Ddep11=true"
  ];

  doCheck = false; # fails at least 1 test

  postInstall = ''
    moveToOutput "share/installed-tests" "$installedTests"
  '';

  meta = with stdenv.lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = https://people.freedesktop.org/~hughsient/appstream-glib/;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lethalman matthewbauer ];
  };
}
