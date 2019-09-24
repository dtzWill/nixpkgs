{ stdenv, fetchFromGitHub, cmake, gettext, libxml2, pkgconfig, txt2man, vala_0_40, wrapGAppsHook
, gsettings-desktop-schemas, gtk3, keybinder3, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "peek";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "phw";
    repo = pname;
    rev = version;
    sha256 = "0q70hz9anqywqgksd43i8v9ijwy6djyzwnzzd94j44xqwsk9zdbb";
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
