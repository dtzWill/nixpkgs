{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, dbus, libcap, systemd }:

stdenv.mkDerivation rec {
  pname = "rtkit";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "heftig";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1bay9riwigrf563g0lznmrx6565kijqkvrf75hw9z79mrckix4mb";
  };

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ dbus libcap systemd ];
  NIX_LDFLAGS = [ "-lrt" ];

  meta = with stdenv.lib; {
    homepage = http://0pointer.de/blog/projects/rtkit;
    description = "A daemon that hands out real-time priority to processes";
    license = with licenses; [ gpl3 bsd0 ]; # lib is bsd license
    platforms = platforms.linux;
  };
}
