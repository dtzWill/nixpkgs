{ stdenv, fetchFromGitHub, cmake, gettext, libxml2, pkgconfig, txt2man, vala_0_40, wrapGAppsHook
, gsettings-desktop-schemas, gtk3, keybinder3, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "peek";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "phw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qwcxaay7vig1b5yq91y1dlnhd826cnp3pzcicq1rp6xp6nxd08a";
  };

  preConfigure = ''
    gappsWrapperArgs+=(--prefix PATH : ${stdenv.lib.makeBinPath [ ffmpeg ]})
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkgconfig
    libxml2.bin
    txt2man
    vala_0_40 # See https://github.com/NixOS/nixpkgs/issues/58433
    wrapGAppsHook
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    keybinder3
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = https://github.com/phw/peek;
    description = "Simple animated GIF screen recorder with an easy to use interface";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ puffnfresh ];
    platforms   = platforms.linux;
  };
}
