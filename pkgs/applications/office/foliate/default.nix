{ stdenv, fetchFromGitHub, meson, ninja, gettext, pkgconfig, python3
, wrapGAppsHook, gobject-introspection
, gjs, gtk3, gsettings-desktop-schemas, webkitgtk, glib
, desktop-file-utils, hicolor-icon-theme /* setup hook */
, libarchive
/*, hyphen */
, dict }:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "e93c98e48f5e306468913627fe3b442484370403";

  # Fetch this from gnome mirror if/when available there instead!
  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = version;
    sha256 = "0y9vnfkd49hnh4c9m1w97f8m6wndqwcmicx842gp3ynyzc84rvs9";
  };

  nativeBuildInputs = [
    meson ninja
    pkgconfig
    gettext
    desktop-file-utils
    wrapGAppsHook
    hicolor-icon-theme
  ];

  buildInputs = [
    glib
    gtk3
    gjs
    webkitgtk
    gsettings-desktop-schemas
    gobject-introspection
    libarchive
    # TODO: Add once packaged, unclear how language packages best handled
    # hyphen
    dict # dictd for offline dictionary support
    python3
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
    sed -e \
    "2i\
      imports.package._findEffectiveEntryPointName = () => 'com.github.johnfactotum.Foliate'\
    " \
      -i $out/bin/com.github.johnfactotum.Foliate

    ln -s $out/bin/com.github.johnfactotum.Foliate $out/bin/foliate
  '' + # for kindle, mobi support
  ''
    patchShebangs share/foliate/assets/KindleUnpack/*py

    gappsWrapperArgs+=(--prefix PATH : "${python3}/bin")
  '';
}
