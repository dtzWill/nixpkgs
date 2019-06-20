{ stdenv, fetchFromGitLab, meson, ninja, gettext, cargo, rustc, python3, rustPlatform, pkgconfig, gtksourceview
, hicolor-icon-theme, glib, libhandy, gtk3, libsecret, gspell, dbus, openssl, sqlite, gst_all_1, wrapGAppsHook }:

rustPlatform.buildRustPackage rec {
  version = "4.0.0.0.1"; # not really
  pname = "fractal";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    #rev = version;
    rev = "114fc20c1d834375114f28e69b23005a217bd6a4"; # 2019-06-19
    sha256 = "1988kysq1mx4kiyabavrhk4rafmxxr9w2p70c055wc5f93gi6ikl";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext cargo rustc python3 wrapGAppsHook
  ];
  buildInputs = [
    glib gtk3 libhandy dbus gspell openssl sqlite
    gtksourceview hicolor-icon-theme
  ] ++ builtins.attrValues { inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav gst-editing-services; };

  postPatch = ''
    patchShebangs scripts/meson_post_install.py

    substituteInPlace scripts/test.sh --replace /usr/bin/sh '/usr/bin/env sh'
    chmod +x scripts/test.sh
    patchShebangs scripts/test.sh
    substituteInPlace scripts/test.sh --replace 'cargo test -j 1' 'cargo test'

    substituteInPlace meson.build \
      --replace "name_suffix = '" "name_suffix = ' (git)" \
      --replace "version_suffix = '" "version_suffix = '-${builtins.substring 0 8 src.rev}"
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  cargoSha256 = "15v4nynfjp6lpa9vhsrb55ywr6j5ibrambmqr5qlmwbmn4i3861p";

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = https://gitlab.gnome.org/GNOME/fractal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

