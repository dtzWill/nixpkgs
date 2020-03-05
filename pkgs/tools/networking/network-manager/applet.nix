{ stdenv, fetchurl, fetchFromGitLab, meson, ninja, intltool, pkgconfig
, networkmanager, libnma, gnome3
, libnotify, libsecret, polkit, modemmanager, libxml2 
, glib-networking, gsettings-desktop-schemas
, libgudev, jansson, wrapGAppsHook, python3, gtk3
, libappindicator-gtk3
# TODO: revamp
, withGnome ? false
}:

stdenv.mkDerivation rec {
  pname = "network-manager-applet";
  #version = "1.8.22";
  version = "unstable-2020-02-14";

  #src = fetchurl {
  #  url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
  #  sha256 = "1vbyhxknixyrf75pbjl3rxcy32m8y9cx5s30s3598vgza081rvzb";
  #};
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "0b58efdd2e5aab68843cd354d921580bc3b5b514";
    sha256 = "1xal5n05k3nal951irdjb26i8zc01x43yfhr83kxwnfj1zmfy7ic";
  };

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  outputs = [ "out" "lib" "dev" "man" ];

  buildInputs = [
    gtk3 networkmanager libnotify libsecret gsettings-desktop-schemas
    polkit libgudev
    modemmanager jansson glib-networking
    libappindicator-gtk3 gnome3.adwaita-icon-theme
    (libnma.override { inherit withGnome; })
  ];

  nativeBuildInputs = [ meson ninja intltool pkgconfig wrapGAppsHook python3 libxml2 ];

  # Needed for wingpanel-indicator-network and switchboard-plug-network
  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py

    substituteInPlace src/wireless-security/eap-method.c --subst-var-by NM_APPLET_GSETTINGS $lib/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanagerapplet";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/NetworkManager;
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom ];
    platforms = platforms.linux;
  };
}
