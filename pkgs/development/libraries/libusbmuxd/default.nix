{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libplist }:

stdenv.mkDerivation rec {
  pname = "libusbmuxd";
  version = "2019-08-03";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = pname;
    rev = "b097ea39f391f5c2c83d8f4687843a3634f7cd54";
    sha256 = "1yziqwqaqrcdisq3nb78hb1yqljl7wd1k7hv3v2cmc8a5ak1m361";
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
