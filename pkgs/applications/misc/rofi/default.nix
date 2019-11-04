{ stdenv, lib, fetchurl, fetchFromGitHub
, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
}:

stdenv.mkDerivation rec {
  pname = "rofi-unwrapped";
  version = "1.5.4-next";

  #src = fetchurl {
  #  url = "https://github.com/davatorium/rofi/releases/download/${version}/rofi-${version}.tar.gz";
  #  sha256 = "1g1170zmh5v7slnm1sm2d08jgz6icikf8rm17apm1bjzzyw1lhk7";
  #};

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi";
    rev = "5f57519940b033740f607bb52dfddc7457ca5c20";
    sha256 = "0ccfpwh0ppn0f3569pzy508z3lisyr3cba8f3429b1i89snjyi1d";
    fetchSubmodules = true;
  };

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libxkbcommon pango cairo git bison flex librsvg check
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
