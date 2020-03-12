{ config, stdenv, lib, fetchurl, intltool, pkgconfig, python3Packages, bluez, gtk3
, obex_data_server, xdg_utils, dnsmasq, dhcp, iproute, libappindicator-gtk3, networkmanager
, hicolor-icon-theme, librsvg, wrapGAppsHook, gobject-introspection
, withPulseAudio ? config.pulseaudio or stdenv.isLinux, libpulseaudio }:

let
  pythonPackages = python3Packages;
  binPath = lib.makeBinPath [ xdg_utils dnsmasq dhcp iproute ];

in stdenv.mkDerivation rec {
  pname = "blueman";
  version = "2.1.2";

  src = fetchurl {
    url = "https://github.com/blueman-project/blueman/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "0k49hgyglsrlszckjzrvlsdm9ysns3qgvczgcmwaz02vvwnb4zai";
  };

  nativeBuildInputs = [
    gobject-introspection intltool pkgconfig pythonPackages.cython
    pythonPackages.wrapPython wrapGAppsHook
  ];

  buildInputs = [ bluez gtk3 pythonPackages.python librsvg hicolor-icon-theme iproute libappindicator-gtk3 networkmanager ]
                ++ pythonPath
                ++ lib.optional withPulseAudio libpulseaudio;

  postPatch = lib.optionalString withPulseAudio ''
    sed -i 's,CDLL(",CDLL("${libpulseaudio.out}/lib/,g' blueman/main/PulseAudioUtils.py
  '';

  pythonPath = with pythonPackages; [ pygobject3 pycairo ];

  propagatedUserEnvPkgs = [ obex_data_server ];

  configureFlags = [
    (lib.enableFeature withPulseAudio "pulseaudio")
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
  ];

  postFixup = ''
    makeWrapperArgs="--prefix PATH ':' ${binPath}"
    # This mimics ../../../development/interpreters/python/wrap.sh
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
    wrapPythonProgramsIn "$out/libexec" "$out $pythonPath"
  '';

  meta = with lib; {
    homepage = https://github.com/blueman-project/blueman;
    description = "GTK-based Bluetooth Manager";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
