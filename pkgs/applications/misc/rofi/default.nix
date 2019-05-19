{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libxkbcommon, pango, which, git
, cairo, libxcb, xcbutil, xcbutilwm, xcbutilxrm, libstartup_notification
, bison, flex, librsvg, check
}:

stdenv.mkDerivation rec {
  #version = "1.5.2";
  #name = "rofi-unwrapped-${version}";
  pname = "rofi"; # -unwrapped
  version = "2019-05-19";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = pname;
    rev = "361ce7d6fc9c837d6a263a9f3405e3466668523a";
    fetchSubmodules = true;
    sha256 = "15yd7xjmamij22svyjzn5idjv5m9nbfrylpc9h87rvwjcjss02c8";
  };
  #src = fetchurl {
  #  url = "https://github.com/DaveDavenport/rofi/releases/download/${version}/rofi-${version}.tar.gz";
  #  sha256 = "1rczxz6l32vnclarzga1sm1d5iq9rfscb9j7f8ih185n59hf0517";
  #};

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

  meta = with stdenv.lib; {
    description = "Window switcher, run dialog and dmenu replacement";
    homepage = https://github.com/davatorium/rofi;
    license = licenses.mit;
    maintainers = with maintainers; [ mbakke garbas ma27 ];
    platforms = with platforms; linux;
  };
}
