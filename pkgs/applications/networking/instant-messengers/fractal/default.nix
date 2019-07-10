{ stdenv, fetchFromGitLab, meson, ninja, gettext, cargo, rustc, python3, rustPlatform, pkgconfig, gtksourceview
, hicolor-icon-theme, glib, libhandy, gtk3, libsecret, dbus, openssl, gspell, sqlite, gst_all_1, wrapGAppsHook, fetchpatch }:

rustPlatform.buildRustPackage rec {
  version = "4.0.0.0.1"; # not really
  pname = "fractal";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    #rev = version;
    rev = "c5c17a492f1807dc63597de926da85bffba0db25"; # 2019-06-28
    sha256 = "1w3yiwmn86lbi4bj23if2y7d4rlmnirxi1fzzjcdcp8zzx4yx9ab";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext cargo rustc python3 wrapGAppsHook
  ];
  buildInputs = [
    glib gtk3 libhandy dbus gspell openssl sqlite
    gtksourceview hicolor-icon-theme
  ] ++ builtins.attrValues { inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav gst-editing-services; };

  patches = [
  ];

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

  cargoSha256 = "0ca4309cmd3zac6rdk6496nyppdhrmka3li2pbx9zlzml6hj84da";

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = https://gitlab.gnome.org/GNOME/fractal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

