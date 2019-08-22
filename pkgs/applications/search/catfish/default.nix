{ stdenv, fetchurl, file, which, intltool, gobject-introspection,
  findutils, xdg_utils, gnome3, gtk3, python3Packages, hicolor-icon-theme,
  wrapGAppsHook,
  atk, cairo
}:

python3Packages.buildPythonApplication rec {
  majorver = "1.4";
  minorver = "9";
  version = "${majorver}.${minorver}";
  pname = "catfish";

  src = fetchurl {
    url = "https://archive.xfce.org/src/apps/${pname}/${majorver}/${pname}-${version}.tar.bz2";
    sha256 = "0kllxm4jdasskfs29q6p25z4p455jcv21zyfkn0y8dj3h22rp8r9";
  };

  nativeBuildInputs = [
    python3Packages.distutils_extra
    file
    which
    intltool
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    gtk3
    gnome3.dconf
    hicolor-icon-theme
    #wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
    python3Packages.pyxdg
    python3Packages.ptyprocess
    python3Packages.pycairo
    python3Packages.pexpect
    python3Packages.dbus-python
    xdg_utils
    findutils
    gtk3
    cairo
    atk
  ];

  # Explicitly set the prefix dir in "setup.py" because setuptools is
  # not using "$out" as the prefix when installing catfish data. In
  # particular the variable "__catfish_data_directory__" in
  # "catfishconfig.py" is being set to a subdirectory in the python
  # path in the store.
  postPatch = ''
    sed -i "/^        if self.root/i\\        self.prefix = \"$out\"" setup.py
  '';

  # Disable check because there is no test in the source distribution
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://docs.xfce.org/apps/catfish/start;
    description = "A handy file search tool";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK+3.
      You can configure it to your needs by using several command line
      options.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
