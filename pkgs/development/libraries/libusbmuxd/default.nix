{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = version;
    sha256 = "1r4448q8pci9bxl0smlvswk8av69z48b30a064q4s5cmpnsgskng";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libplist ];

  meta = with stdenv.lib; {
    description = "A client library to multiplex connections from and to iOS devices";
    homepage    = https://github.com/libimobiledevice/libusbmuxd;
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ infinisil ];
  };
}
