{ stdenv, fetchurl, pkgconfig, dbus, libgcrypt, pam, python2, glib, libxslt
, gettext, gcr, libcap_ng, libselinux, p11-kit, openssh, wrapGAppsHook
, docbook_xsl, docbook_xml_dtd_43, gnome3, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hqrsh5g9q9lm190f0m85q4nki8k4ng7wphl6qbccdry59aakkg9";
  };

  outputs = [ "out" "dev" ];

  buildInputs = [
    glib libgcrypt pam openssh libcap_ng libselinux
    gcr p11-kit
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig gettext libxslt docbook_xsl docbook_xml_dtd_43 wrapGAppsHook
  ];

  configureFlags = [
    "--with-pkcs11-config=${placeholder "out"}/etc/pkcs11/" # installation directories
    "--with-pkcs11-modules=${placeholder "out"}/lib/pkcs11/"
  ];

  #patches = [
  #  ./0001-dbus-Implement-secret-portal-backend.patch
  #];

  postPatch = ''
    patchShebangs build
  '';

  # Tends to fail non-deterministically.
  # - https://github.com/NixOS/nixpkgs/issues/55293
  # - https://github.com/NixOS/nixpkgs/issues/51121
  doCheck = false;

  # In 3.20.1, tests do not support Python 3
  checkInputs = [ dbus python2 ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  # Use wrapped gnome-keyring-daemon with cap_ipc_lock=ep
  postFixup = ''
    files=($out/etc/xdg/autostart/* $out/share/dbus-1/services/*)

    for file in ''${files[*]}; do
      substituteInPlace $file \
        --replace "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
    done
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-keyring";
      attrPath = "gnome3.gnome-keyring";
    };
  };

  meta = with stdenv.lib; {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = https://wiki.gnome.org/Projects/GnomeKeyring;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
