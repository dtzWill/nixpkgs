{ stdenv, fetchFromGitHub, meson, ninja, gettext, pkgconfig, python3
, wrapGAppsHook, gobject-introspection
, gjs, gtk3, gsettings-desktop-schemas, webkitgtk, glib
, desktop-file-utils
/*, hyphen */
, dict }:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "1.5.0";

  # Fetch this from gnome mirror if/when available there instead!
  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = version;
    sha256 = "106852dn6h8jpqpnkdppd2836w6n1w8cwk4kgrdfcji4m6hc4y2a";
  };

  nativeBuildInputs = [
    meson ninja
    pkgconfig
    gettext
    python3
    desktop-file-utils
    wrapGAppsHook
  ];
  buildInputs = [
    glib
    gtk3
    gjs
    webkitgtk
    gsettings-desktop-schemas
    gobject-introspection
    # TODO: Add once packaged, unclear how language packages best handled
    # hyphen
    dict # dictd for offline dictionary support
  ];

  doCheck = true;

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py
    patchShebangs build-aux/meson/postinstall.py
  '';

  # Kludge so gjs can find resources by using the unwrapped name
  # Improvements/alternatives welcome, but this seems to work for now :/.
  # See: https://github.com/NixOS/nixpkgs/issues/31168#issuecomment-341793501
  postInstall = ''
    sed -ie "2iimports.package._findEffectiveEntryPointName = () => 'com.github.johnfactotum.Foliate'" \
      $out/bin/com.github.johnfactotum.Foliate
  '';
}
