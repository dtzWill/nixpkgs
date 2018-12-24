{ stdenv, fetchurl, fetchpatch, pkgconfig, gettext, perl, makeWrapper, shared-mime-info, isocodes
, expat, glib, cairo, pango, gdk_pixbuf, atk, at-spi2-atk, gobject-introspection
, xorg, epoxy, json-glib, libxkbcommon, gmp, gnome3
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux, mesa_noglu, wayland, wayland-protocols
, xineramaSupport ? stdenv.isLinux
, cupsSupport ? stdenv.isLinux, cups ? null
, AppKit, Cocoa
}:

assert cupsSupport -> cups != null;

with stdenv.lib;

let
  version = "3.24.2";
in
stdenv.mkDerivation rec {
  name = "gtk+3-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk+/${stdenv.lib.versions.majorMinor version}/gtk+-${version}.tar.xz";
    sha256 = "14l8mimdm44r3h5pn5hzigl1z25jna8jxvb16l88v4nc4zj0afsv";
  };

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [ pkgconfig gettext gobject-introspection perl makeWrapper ];

  patches = [
    ./3.0-immodules.cache.patch
    (fetchpatch {
      name = "Xft-setting-fallback-compute-DPI-properly.patch";
      url = "https://bug757142.bugzilla-attachments.gnome.org/attachment.cgi?id=344123";
      sha256 = "0g6fhqcv8spfy3mfmxpyji93k8d4p4q4fz1v9a1c1cgcwkz41d7p";
    })
    # XXX: DTZ: This is included in patch series listed below
    # (but keeping this as a reminder of such when merging)
    # https://gitlab.gnome.org/GNOME/gtk/issues/1521
    #(fetchpatch {
    #  url = https://gitlab.gnome.org/GNOME/gtk/commit/2905fc861acda3d134a198e56ef2f6c962ad3061.patch;
    #  sha256 = "0y8ljny59kgdhrcfpimi2r082bax60d5kflw1qj9k1mnzjcvjjwl";
    #})
    # Upstream patches
    ./3.24.2-16/0001-imwayland-Handle-enter-and-leave-events.patch
    ./3.24.2-16/0002-imwayland-rearrange-functions-to-remove-prototypes.patch
    ./3.24.2-16/0003-imwayland.c-fix-formatting.patch
    ./3.24.2-16/0004-placesview-Set-.error-style-if-unsupported-protocol.patch
    ./3.24.2-16/0005-placesview-List-only-available-protocols-as-availabl.patch
    ./3.24.2-16/0006-imwayland-Respect-maximum-length-of-4000-Bytes-on-st.patch
    ./3.24.2-16/0007-demos-gtk-demo-combobox-fix-typo.patch
    ./3.24.2-16/0008-statusicon-Create-pixbuf-at-correct-size.patch
    ./3.24.2-16/0009-Revert-Fix-deprecation-warnings.patch
    ./3.24.2-16/0010-x11-Be-a-lot-more-careful-about-setting-ParentRelati.patch
    ./3.24.2-16/0011-x11-Fix-deprecation-macro-use.patch
  ];

  buildInputs = [ libxkbcommon epoxy json-glib isocodes ]
    ++ optional stdenv.isDarwin AppKit;
  propagatedBuildInputs = with xorg; with stdenv.lib;
    [ expat glib cairo pango gdk_pixbuf atk at-spi2-atk gnome3.gsettings-desktop-schemas
      libXrandr libXrender libXcomposite libXi libXcursor libSM libICE ]
    ++ optional stdenv.isDarwin Cocoa  # explicitly propagated, always needed
    ++ optionals waylandSupport [ mesa_noglu wayland wayland-protocols ]
    ++ optional xineramaSupport libXinerama
    ++ optional cupsSupport cups;
  #TODO: colord?

  # demos fail to install, no idea where's the problem
  # preConfigure = "sed '/^SRC_SUBDIRS /s/demos//' -i Makefile.in";

  enableParallelBuilding = true;

  configureFlags = optional stdenv.isDarwin [
    "--disable-debug"
    "--disable-dependency-tracking"
    "--disable-glibtest"
  ] ++ optional (stdenv.isDarwin && !x11Support)
    "--enable-quartz-backend"
    ++ optional x11Support [
    "--enable-x11-backend"
  ] ++ optional waylandSupport [
    "--enable-wayland-backend"
  ] ++ [
    "--enable-installed-tests"
  ];

  preBuild = ''
    find ..
    echo "make clean XXX"
    make clean
    echo "make clean YYY"
    find ..
  '';

  doCheck = false; # needs X11

  postInstall = optionalString (!stdenv.isDarwin) ''
    substituteInPlace "$out/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-cups.la" \
      --replace '-L${gmp.dev}/lib' '-L${gmp.out}/lib'
    # The updater is needed for nixos env and it's tiny.
    moveToOutput bin/gtk-update-icon-cache "$out"
    # Launcher
    moveToOutput bin/gtk-launch "$out"

    # TODO: patch glib directly
    for f in $dev/bin/gtk-encode-symbolic-svg; do
      wrapProgram $f --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk+";
      attrPath = "gtk3";
    };
  };

  meta = with stdenv.lib; {
    description = "A multi-platform toolkit for creating graphical user interfaces";

    longDescription = ''
      GTK+ is a highly usable, feature rich toolkit for creating
      graphical user interfaces which boasts cross platform
      compatibility and an easy to use API.  GTK+ it is written in C,
      but has bindings to many other popular programming languages
      such as C++, Python and C# among others.  GTK+ is licensed
      under the GNU LGPL 2.1 allowing development of both free and
      proprietary software with GTK+ without any license fees or
      royalties.
    '';

    homepage = https://www.gtk.org/;

    license = licenses.lgpl2Plus;

    maintainers = with maintainers; [ raskin vcunat lethalman ];
    platforms = platforms.all;
  };
}
