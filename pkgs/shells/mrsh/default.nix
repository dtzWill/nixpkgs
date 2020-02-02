{ stdenv, lib, fetchFromGitHub, meson, ninja, pkgconfig
#, readline
, libedit
}:

stdenv.mkDerivation rec {
  pname   = "mrsh";
  version = "2020-01-27";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "d9763a32e7da572677d1681bb1fc67f117d641f3";
    sha256 = "1vnn0dah8h8lf2pzj3xq5xzl8dh34vlqkarniydji6nsym576vzs";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ /* readline */ libedit ];

  mesonFlags = [ "-Dreadline-provider=editline" ];

  meta = with stdenv.lib; {
    description = "A minimal POSIX shell";
    homepage = "https://mrsh.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
