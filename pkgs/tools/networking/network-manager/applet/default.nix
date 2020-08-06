{ stdenv
, fetchFromGitLab
, fetchurl
, meson
, ninja
, gettext
, pkg-config
, networkmanager
, gnome3
, libnotify
, libsecret
, polkit
, modemmanager
, libnma
, mobile-broadband-provider-info
, glib-networking
, gsettings-desktop-schemas
, libgudev
, jansson
, wrapGAppsHook
, gobject-introspection
, python3
, gtk3
, libappindicator-gtk3
}:

stdenv.mkDerivation rec {
  pname = "network-manager-applet";
   version = "1.18.0";
  #version = "unstable-2020-02-14";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "12xiy8g8qk18jvxvn78mvq03zvzp06bww49na765jjw0rq541fyx";
  };
  #src = fetchFromGitLab {
  #  domain = "gitlab.gnome.org";
  #  owner = "GNOME";
  #  repo = pname;
  #  rev = "0b58efdd2e5aab68843cd354d921580bc3b5b514";
  #  sha256 = "1xal5n05k3nal951irdjb26i8zc01x43yfhr83kxwnfj1zmfy7ic";
  #};

  mesonFlags = [
    "-Dselinux=false"
    "-Dappindicator=yes"
  ];

  outputs = [ "out" "man" ];

  buildInputs = [
    libnma
    gtk3
    networkmanager
    libnotify
    libsecret
    gsettings-desktop-schemas
    polkit
    libgudev
    modemmanager
    jansson
    glib-networking
    libappindicator-gtk3
    gnome3.adwaita-icon-theme
  ];

  # nativeBuildInputs = [ meson ninja intltool pkgconfig wrapGAppsHook python3 libxml2 ];
  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
    gobject-introspection
    python3
  ];

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
    homepage = "https://gitlab.gnome.org/GNOME/network-manager-applet/";
    description = "NetworkManager control applet for GNOME";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom ];
    platforms = platforms.linux;
  };
}
