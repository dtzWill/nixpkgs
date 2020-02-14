{ stdenv, lib, fetchFromGitHub, meson, ninja, pkgconfig
#, readline
, libedit
}:

stdenv.mkDerivation rec {
  pname   = "mrsh";
  version = "2020-02-04";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "mrsh";
    rev = "e902a4fabad3defd32be60551f32fbaa15aec831";
    sha256 = "1f6r1a3w8kwjkprfrfn6h1z2n9ww8h22af2jspvv7mm3ki4nqs3b";
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
