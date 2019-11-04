{ stdenv, fetchurl, udev, intltool, pkgconfig, glib, xmlto, wrapGAppsHook
, docbook_xml_dtd_412, docbook_xsl
, libxml2, desktop-file-utils, libusb1, cups, gdk-pixbuf, pango, atk, libnotify
, gobject-introspection, libsecret
, cups-filters
, pythonPackages
}:

stdenv.mkDerivation rec {
  pname = "system-config-printer";
  version = "1.5.12";

  src = fetchurl {
    url = "https://github.com/OpenPrinting/system-config-printer/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "050yrx1vfh9f001qsn06y1jcidxq0ymxr64kxykasr0zzryp25kb";
  };

  patches = [ ./detect_serverbindir.patch ];

  buildInputs = [
    glib udev libusb1 cups
    pythonPackages.python
    libnotify gobject-introspection gdk-pixbuf pango atk
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
