{ stdenv, fetchFromGitHub, fetchpatch
, libdrm, json_c, pciutils
, meson, ninja, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "drm_info";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ascent12";
    repo = "drm_info";
    rev = "v${version}";
    sha256 = "0s4zp8xz21zcpinbcwdvg48rf0xr7rs0dqri28q093vfmllsk36f";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ascent12/drm_info/commit/0d92b0372557084f8c7d19dce6dc4b1bffc3e011.patch";
      sha256 = "0x8d5d6g9n1xqvyz2ya11rfziwwxsaac00n70bccj58hfwk3nfvq";
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ libdrm json_c pciutils ];

  meta = with stdenv.lib; {
    description = "Small utility to dump info about DRM devices.";
    homepage = "https://github.com/ascent12/drm_info";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.linux;
  };
}
