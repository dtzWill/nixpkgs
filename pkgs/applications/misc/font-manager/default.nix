{ stdenv, fetchFromGitHub, meson, ninja, gettext, python3,
  pkgconfig, libxml2, json-glib , sqlite, itstool, librsvg,
  vala, gtk3, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
#  version = "0.7.5";
  version = "unstable-2020-01-01";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = pname;
    #rev = version;
    rev = "fe113ccb0199c6b87f9810c3937a1d84891460bb";
    sha256 = "1xh9bz26cs0fnzkya2p7s96b7y75xchfvwphbh433c2hjy0kq2mk";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gettext
    python3
    itstool
    desktop-file-utils
    vala
    gnome3.yelp-tools
    wrapGAppsHook
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gtk3
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Ddisable_pycompile=true"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://fontmanager.github.io/;
    description = "Simple font management for GTK desktop environments";
    longDescription = ''
      Font Manager is intended to provide a way for average users to
      easily manage desktop fonts, without having to resort to command
      line tools or editing configuration files by hand. While designed
      primarily with the Gnome Desktop Environment in mind, it should
      work well with other GTK desktop environments.

      Font Manager is NOT a professional-grade font management solution.
    '';
    license = licenses.gpl3;
    repositories.git = https://github.com/FontManager/master;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
