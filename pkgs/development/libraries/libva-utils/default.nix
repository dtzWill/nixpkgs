{ stdenv, fetchFromGitHub, pkgconfig
, libdrm, libva, libX11, libXext, libXfixes, wayland, meson, ninja
}:

stdenv.mkDerivation rec {
  name = "libva-utils-${version}";
  #inherit (libva) version;
  version = "2.5.0";

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "1cd4xpm0c5ryl2qx2vm6vhyl1w0s7y3i9ih2xifdhd94mp8m81n3";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ libdrm libva libX11 libXext libXfixes wayland ];

  mesonFlags = [
    "-Ddrm=true"
    "-Dx11=true"
    "-Dwayland=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "VAAPI tools: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
