{ at-spi2-core, cmake, dbus, dbus-glib, docbook_xsl, epoxy, fetchFromGitHub
, glib, gtk3, harfbuzz, libXdmcp, libXtst, libpthreadstubs
, libselinux, libsepol, libtasn1, libxkbcommon, libxslt, p11-kit, pcre
, pkgconfig, stdenv, utillinuxMinimal, vte, wrapGAppsHook, xmlto
}:

stdenv.mkDerivation rec {
  pname = "roxterm";
  version = "3.8.4";

  src = fetchFromGitHub {
    owner = "realh";
    repo = "roxterm";
    rev = version;
    sha256 = "0jvjihq3s9m8sm46kvkp60xw28jm8n6kvl43akdjgccfln4rlipy";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapGAppsHook libxslt ];

  buildInputs =
    [ gtk3 dbus dbus-glib vte pcre harfbuzz libpthreadstubs libXdmcp
      utillinuxMinimal glib docbook_xsl xmlto libselinux
      libsepol libxkbcommon epoxy at-spi2-core libXtst libtasn1 p11-kit
    ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/realh/roxterm";
    license = licenses.gpl3;
    description = "Tabbed, VTE-based terminal emulator";
    longDescription = ''
      Tabbed, VTE-based terminal emulator. Similar to gnome-terminal without
      the dependencies on Gnome.
    '';
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
