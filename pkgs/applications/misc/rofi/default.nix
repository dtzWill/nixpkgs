{ stdenv, lib, fetchurl, fetchFromGitHub
, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, libjpeg, check
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "unstable-2019-06-26";

  #src = fetchurl {
  #  url = "https://github.com/davatorium/rofi/releases/download/${version}/rofi-${version}.tar.gz";
  #  sha256 = "1g1170zmh5v7slnm1sm2d08jgz6icikf8rm17apm1bjzzyw1lhk7";
  #};

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = "35d2c341c84bfae2365439267d08efa270badacf";
    sha256 = "1rbgcfgp2yylapzgj2yqz4ik7f4ixvncfi3qnmpz8a25ppnyfvjn";
    fetchSubmodules = true;
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg libjpeg check
    libstartup_notification libxcb xcbutil xcbutilwm xcbutilxrm which
  ];

  doCheck = false;

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = "https://github.com/davatorium/rofi";
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke ma27 ];
    platforms = with platforms; linux;
  };
}
