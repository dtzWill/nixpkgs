{ stdenv, fetchFromGitHub, pkgconfig, gettext, glib, gtk3, libnotify }:

stdenv.mkDerivation rec {

  name = "cbatticon-${version}";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "valr";
    repo = "cbatticon";
    rev = version;
    sha256 = "0kw09d678sd3m18fmi4380sl4a2m5lkfmq0kps16cdmq7z80rvaf";
  };

  patchPhase = ''
    sed -i -e 's/ -Wno-format//g' Makefile
  '';

  makeFlags = "PREFIX=$(out)";

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs =  [ glib gtk3 libnotify ];

  meta = with stdenv.lib; {
    description = "Lightweight and fast battery icon that sits in the system tray";
    homepage = https://github.com/valr/cbatticon;
    license = licenses.gpl2;
    maintainers = [ maintainers.domenkozar ];
    platforms = platforms.linux;
  };
}
