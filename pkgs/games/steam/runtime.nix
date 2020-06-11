{ stdenv, steamArch, fetchurl, }:

stdenv.mkDerivation rec {

  name = "steam-runtime";
  # from https://repo.steampowered.com/steamrt-images-scout/snapshots/
  version = "0.20200505.0";

  src =
    if steamArch == "amd64" then fetchurl {
      url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/com.valvesoftware.SteamRuntime.Platform-amd64,i386-scout-runtime.tar.gz";
      sha256 = "0mg1c2m9dnc9fl2wdyjwb87ma4qpxax9qax6ndp72yw7sgkdwrfj";
      name = "scout-runtime-${version}.tar.gz";
    } else fetchurl {
      url = "https://repo.steampowered.com/steamrt-images-scout/snapshots/${version}/com.valvesoftware.SteamRuntime.Platform-i386-scout-runtime.tar.gz";
      sha256 = "0723lr0dz7i20ibcgh9lgjv3m723j9al0zki8kc9a477hjcf6z8k";
      name = "scout-runtime-i386-${version}.tar.gz";
    };

  buildCommand = ''
    mkdir -p $out
    tar -C $out -x --strip=1 -f $src files/
  '';

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = https://github.com/ValveSoftware/steam-runtime;
    license = licenses.unfreeRedistributable; # Includes NVIDIA CG toolkit
    maintainers = with maintainers; [ hrdinka abbradar ];
  };
}
