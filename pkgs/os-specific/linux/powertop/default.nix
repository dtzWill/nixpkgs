{ stdenv, fetchFromGitHub, fetchpatch, gettext, libnl, ncurses, pciutils, autoreconfHook, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  pname = "powertop";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mm1hf92vdy15n4y15wzp7hxv12p8s09g6j2aqsfwa7npqrdzcmi";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gettext libnl ncurses pciutils zlib ];

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace "/sbin/modprobe" "modprobe" \
      --replace "/bin/mount" "mount"
    substituteInPlace src/calibrate/calibrate.cpp --replace "/usr/bin/xset" "xset"

    echo "v${version}" > version-long
    echo '"v${version}"' > version-short
  '';

  meta = with stdenv.lib; {
    description = "Analyze power consumption on Intel-based laptops";
    homepage = https://01.org/powertop;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
