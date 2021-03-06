{ stdenv, fetchFromGitHub
, ninja
, meson
, pkgconfig
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
, gtk3
, gst_all_1
, gobject-introspection
, python3Packages
, file
, cairo
, gettext
, gnome3
}:

python3Packages.buildPythonApplication rec {

  format = "other"; # no setup.py

  pname = "cozy";
  version = "0.6.11";

  # Temporary fix
  # See https://github.com/NixOS/nixpkgs/issues/57029
  # and https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  src = fetchFromGitHub {
    owner = "geigi";
    repo = pname;
    rev = version;
    sha256 = "07pkamxakpqp6lpzxi6krx938cy43d3nd4fh15lidxd9p11a2jni";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    cairo
    gettext
    gnome3.adwaita-icon-theme
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-good
    gst-plugins-ugly
    gst-plugins-base
  ]);

  propagatedBuildInputs = with python3Packages; [
    gst-python
    pygobject3
    dbus-python
    mutagen
    peewee
    magic
    distro
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
    substituteInPlace cozy/magic/magic.py --replace "ctypes.util.find_library('magic')" "'${file}/lib/libmagic${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  postInstall = ''
    ln -s $out/bin/com.github.geigi.cozy $out/bin/cozy
  '';

  meta = with stdenv.lib; {
    description = "A modern audio book player for Linux using GTK 3";
    homepage = https://cozy.geigi.de/;
    maintainers = [ maintainers.makefu ];
    license = licenses.gpl3;
  };
}
