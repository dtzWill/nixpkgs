{ stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gtk3
, inkscape
, optipng
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "pop-gtk-theme";
  version = "2020-01-29";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "gtk-theme";
    rev = "b8a8a519a21b10dcfe7a303288dad8d9646199ea";
    sha256 = "0xv7x92pwg0j5f27iz9pmb42cwnpn9ln411rbd1kwaz0by5kiqaw";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape
    optipng
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    for file in $(find -name render-\*.sh); do
      patchShebangs "$file"

      substituteInPlace "$file" \
        --replace 'INKSCAPE="/usr/bin/inkscape"' \
                  'INKSCAPE="inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="optipng"'
    done
  '';

  meta = with stdenv.lib; {
    description = "System76 Pop GTK+ Theme";
    homepage = "https://github.com/pop-os/gtk-theme";
    license = with licenses; [ gpl3 lgpl21 cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ elyhaka ];
  };
}
