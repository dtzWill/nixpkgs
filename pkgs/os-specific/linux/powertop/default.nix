{ stdenv, fetchFromGitHub, fetchpatch, gettext, libnl, ncurses, pciutils, autoreconfHook, pkgconfig, zlib }:

stdenv.mkDerivation rec {
  pname = "powertop";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "fenrus75";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s4p7763liwaxz969vsxsxyacir2cglnqsfcvv1kak25ndjj9jxy";
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
    homepage = "https://01.org/powertop";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
