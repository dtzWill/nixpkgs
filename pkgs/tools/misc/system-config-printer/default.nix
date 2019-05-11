{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto, wrapGAppsHook
, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop-file-utils, libusb1, cups, gdk_pixbuf, pango, atk, libnotify
, gobject-introspection, libsecret
, cups-filters
, pythonPackages
}:

stdenv.mkDerivation rec {
  pname = "system-config-printer";
  version = "1.5.11";

  src = fetchurl {
    url = "https://github.com/zdohnal/system-config-printer/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "1lq0q51bhanirpjjvvh4xiafi8hgpk8r32h0dj6dn3f32z8pib9q";
  };

  patches = [ ./detect_serverbindir.patch ];

  buildInputs = [
    glib udev libusb1 cups
    pythonPackages.python
    libnotify gobject-introspection gdk_pixbuf pango atk
    libsecret
  ];

  nativeBuildInputs = [
    intltool pkgconfig
    xmlto libxml2 docbook_xml_dtd_412 docbook_xsl desktop-file-utils
    pythonPackages.wrapPython
    wrapGAppsHook
  ];

  pythonPath = with pythonPackages; requiredPythonModules [ pycups pycurl dbus-python pygobject3 requests pycairo pysmbc ];

  configureFlags = [
    "--with-udev-rules"
    "--with-udevdir=${placeholder "out"}/etc/udev"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  stripDebugList = [ "bin" "lib" "etc/udev" ];

  doCheck = false; # generates shebangs in check phase, too lazy to fix

  postInstall =
    ''
      buildPythonPath "$out $pythonPath"
      gappsWrapperArgs+=(
        --prefix PATH : "$program_PATH"
        --set CUPS_DATADIR "${cups-filters}/share/cups"
      )

      find $out/share/system-config-printer -name \*.py -type f -perm -0100 -print0 | while read -d "" f; do
        patchPythonScript "$f"
      done
    '';

  meta = {
    homepage = http://cyberelk.net/tim/software/system-config-printer/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
