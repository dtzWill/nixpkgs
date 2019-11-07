{ stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, gettext
, cargo
, rustc
, python3
, rustPlatform
, pkgconfig
, gtksourceview4
, glib
, libhandy
, gtk3
, dbus
, openssl
, sqlite
, gst_all_1
, cairo
, gdk-pixbuf
, gspell
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "fractal";
#  version = "4.2.1";
  version = "unstable-2019-11-04";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    # rev = version;
    rev = "f0e6e408d3e74d2e27ae0d32d968c7fed7f94ee3";
    sha256 = "0z2x9sxfhzpq4rwy1g87m4i6gygyd5v0id8na5aynfwvlk1mj3x5";
  };

  cargoSha256 = "1n9n4d057cz44sh1iy2hb2adplhnrhvr8drnp0v2h8yw73a5shvv";

  nativeBuildInputs = [
    cargo
    gettext
    meson
    ninja
    pkgconfig
    python3
    rustc
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gspell
    gst_all_1.gst-editing-services
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gst_all_1.gst-validate
    gtk3
    gtksourceview4
    libhandy
    openssl
    sqlite
  ];

  postPatch = ''
    chmod +x scripts/test.sh
    patchShebangs scripts/meson_post_install.py scripts/test.sh

    # Don't limit tests to single thread
    substituteInPlace scripts/test.sh --replace 'cargo test -j 1' 'cargo test'
  '' + stdenv.lib.optionalString true ''
    # When building from non-official-releases, modify the in-app
    # version to indicate it was built from git and what revision.
    substituteInPlace meson.build \
      --replace "name_suffix = '" "name_suffix = ' (git)" \
      --replace "version_suffix = '" "version_suffix = '-${builtins.substring 0 8 src.rev}"
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = https://gitlab.gnome.org/GNOME/fractal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill worldofpeace ];
  };
}

