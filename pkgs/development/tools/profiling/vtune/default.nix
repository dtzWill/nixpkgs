{ stdenv, lib, fetchurl, autoPatchelfHook, wrapGAppsHook
, libarchive

, hwloc
, libndctl
, gdbm
, ncurses5
, readline
, fontconfig
, libxkbcommon
, openssl
, libkrb5
, gtk3
, glib
, gdk-pixbuf
, cairo
, pango
, icu67
, atk
, nss
, cups
, alsa-lib
, mesa
, libdrm
, libGL
, libglvnd
, kmod
, systemdMinimal
, xorg
}:

let
  version = "2022.3.0-195";
  baseVersion = lib.head (lib.splitString "-" version);

  # See the build output for a list of components and their versions
  components = [
    { id = "intel.oneapi.lin.oneapi-common.licensing"; version = "2022.0.1-140"; }
    { id = "intel.oneapi.lin.vtune"; inherit version; }
  ];
in stdenv.mkDerivation {
  pname = "vtune";
  inherit version;

  src = fetchurl {
    #url = "https://registrationcenter-download.intel.com/akdlm/irc_nas/18447/l_oneapi_vtune_p_2022.1.0.98_offline.sh";
    url = "https://registrationcenter-download.intel.com/akdlm/irc_nas/18656/l_oneapi_vtune_p_2022.3.0.195_offline.sh";
    #sha256 = "sha256-Ox0MYhUNhYXegTRMeCk6keXfG49XsdgPXoSkq/yNQ4I=";
    sha256 = "sha256-eSH85/zDuCV1viLZw2vuyWG6Kp+1JiuhagQJC8vS4aY=";
  };

  buildInputs = [
    stdenv.cc.cc.lib

    hwloc
    libndctl
    gdbm
    ncurses5
    readline
    fontconfig
    libxkbcommon
    openssl
    libkrb5
    gtk3
    glib
    gdk-pixbuf
    cairo
    pango
    icu67
    atk
    nss
    cups
    alsa-lib
    mesa
    libdrm
    libGL
    libglvnd
    kmod
    systemdMinimal
  ] ++ (with xorg; [
    libXdamage
    libXrandr
    libxcb
    libxshmfence
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ]);

  autoPatchelfIgnoreMissingDeps = true;

  nativeBuildInputs = [
    libarchive autoPatchelfHook
  ];

  unpackPhase = ''
    bash $src -x
    cd l_oneapi_*

    >&2 echo "All components in the archive:"
    >&2 find packages -type d -maxdepth 1
  '';

  installPhase = let
    commands = map (component: "bsdtar xf packages/${component.id},v=${component.version}/cupPayload.cup --strip-components=1 -C $out/opt/intel") components;
  in ''
    mkdir -p $out/opt/intel $out/bin

    ${builtins.concatStringsSep "\n" commands}

    for executable in "vtune" "vtune-gui" "vtune-agent" "vtune-backend" "vtune-worker"; do
      ln -s $out/opt/intel/vtune/${baseVersion}/bin64/$executable $out/bin/$executable
    done
  '';

  meta = with lib; {
    description = "Performance analysis tool for x86-based machines";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ zhaofengli ];
    platforms = [ "x86_64-linux" ];
  };
}
