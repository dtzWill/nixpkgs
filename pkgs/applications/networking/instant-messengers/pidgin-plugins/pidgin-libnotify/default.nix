{ stdenv, fetchurl, fetchpatch, pidgin, libnotify, autoreconfHook, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  pname = "pidgin-libnotify";
  version = "0.14";

  src = fetchurl {
    url = "mirror://sourceforge/gaim-libnotify/${pname}-${version}.tar.gz";
    sha256 = "1gisxj0a5bg473abq4lm31v62y404cgqy5vlk7rksj0a1vrakx3l";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/d9dd0a3d6049e3785ec85ee5095be6de92177f8d/srcpkgs/pidgin-libnotify/patches/pidgin-libnotify-0.14-libnotify-0.7.patch";
      sha256 = "1nmgp9wplhf8vl8jl9skcpmkgh7azv13y0rr57pi2plqfhdxgj79";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/d9dd0a3d6049e3785ec85ee5095be6de92177f8d/srcpkgs/pidgin-libnotify/patches/pidgin-libnotify-showbutton.patch";
      sha256 = "12w3j03hlr0nqp1yhrczagln0pi59w9qis6msc6i2xjl4nciyyl9";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/void-linux/void-packages/d9dd0a3d6049e3785ec85ee5095be6de92177f8d/srcpkgs/pidgin-libnotify/patches/pidgin-libnotify-getfocus.patch";
      sha256 = "1pwkjrd7mdksawy9axbylhlsv5ah92picjx67kjhbx7yy5d6fgyd";
    })
  ];

  patchFlags = [ "-p0" ];

  postPatch = ''
    substituteInPlace src/Makefile.am \
      --replace '$(LIBPURPLE_LIBDIR)/purple-2' \
                '${placeholder "out"}/lib/purple-2'
    
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool ];
  buildInputs = [ pidgin libnotify ];
}
