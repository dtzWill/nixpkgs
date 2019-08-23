{ lib, mkDerivation, fetchFromGitHub, fetchurl, cgal, boost, gmp, mpfr, flex, bison, dxflib, readline
, qtbase, qmake, libGLU
}:

mkDerivation rec {
  version = "0.9.9";
  pname = "rapcad";

  src = fetchFromGitHub {
    owner = "gilesbathgate";
    repo = pname;
    rev = "v${version}";
    sha256 = "14xyn4x5z56flphyx1m1k7z109ka8gxdnld15m4hvg5j64sbd7ra";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase cgal boost gmp mpfr flex bison dxflib readline libGLU ];

  meta = with lib; {
    license = licenses.gpl3;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    description = ''Constructive solid geometry package'';
    broken = true; # aww
  };
}
