{ stdenv, fetchFromGitHub, pkgconfig
, libdrm, libva, libX11, libXext, libXfixes, wayland, meson, ninja
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  #inherit (libva) version;
  version = "2.6.0.pre1";

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = pname;
    rev    = version;
    sha256 = "0nqdpdwij773mvq7z6hra9pbsyqbkpk2chcskb8q5rgdh52cgjx1";
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
