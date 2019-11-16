{ stdenv, fetchFromGitHub, fetchpatch, autoconf, automake, gettext, intltool
, libtool, pkgconfig, wrapGAppsHook, wrapPython, gobject-introspection
, gtk3, python, pygobject3, pyxdg

, withQuartz ? stdenv.isDarwin, ApplicationServices
, withRandr ? stdenv.isLinux, libxcb
, withDrm ? stdenv.isLinux, libdrm

, withGeolocation ? true
, withCoreLocation ? withGeolocation && stdenv.isDarwin, CoreLocation, Foundation, Cocoa
, withGeoclue ? withGeolocation && stdenv.isLinux, geoclue
}:

stdenv.mkDerivation rec {
  pname = "redshift";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "jonls";
    repo = "redshift";
    rev = "v${version}";
    sha256 = "12cb4gaqkybp4bkkns8pam378izr2mwhr2iy04wkprs2v92j7bz6";
  };

  patches = [
    # https://github.com/jonls/redshift/pull/575
    ./575.patch

    (fetchpatch {
      name = "docs-fix-config-file-path.patch";
      url = "https://github.com/jonls/redshift/commit/001d4aeffadec94368cde5738b957740d2e36980.patch";
      sha256 = "0dr09y1521jamh2p1r5vw23l9hv7yvnb396dghvdbp9glbappqls";
    })
    (fetchpatch {
      name = "prefer-symbolic-icon-if-avail.patch";
      url = "https://github.com/jonls/redshift/commit/dca8334646d8fefeb56332eb1535c595a6599c7d.patch";
      sha256 = "1m0mv8imbikxybl79vm0d3yagr384j8sjv53ixj9wp37wf2a5sii";
    })
    (fetchpatch {
      name = "allow-hash-comment-char.patch";
      url = "https://github.com/jonls/redshift/commit/f7fbbb04c335cd844b97c80128145349854128f4.patch";
      sha256 = "0h1zgdahg3h91gcv6w7migf1ja6k2p7r6l6bh870xqi8h71cpspq";
    })
    (fetchpatch {
      name = "additional-suspend-durations.patch";
      url = "https://github.com/jonls/redshift/commit/2e91da281e1161af594e07eed62b672f9b006a39.patch";
      sha256 = "0dhf75l1x67g8nbwm70gsm5923diwvjlwhh5zyffn5ylbml81cg9";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkgconfig
    wrapGAppsHook
    wrapPython
  ];

  configureFlags = [
    "--enable-randr=${if withRandr then "yes" else "no"}"
    "--enable-geoclue2=${if withGeoclue then "yes" else "no"}"
    "--enable-drm=${if withDrm then "yes" else "no"}"
    "--enable-quartz=${if withQuartz then "yes" else "no"}"
    "--enable-corelocation=${if withCoreLocation then "yes" else "no"}"
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    python
  ] ++ stdenv.lib.optional  withRandr        libxcb
    ++ stdenv.lib.optional  withGeoclue      geoclue
    ++ stdenv.lib.optional  withDrm          libdrm
    ++ stdenv.lib.optional  withQuartz       ApplicationServices
    ++ stdenv.lib.optionals withCoreLocation [ CoreLocation Foundation Cocoa ]
    ;

  pythonPath = [ pygobject3 pyxdg ];

  preConfigure = "./bootstrap";

  postFixup = "wrapPythonPrograms";

  # the geoclue agent may inspect these paths and expect them to be
  # valid without having the correct $PATH set
  postInstall = ''
    substituteInPlace $out/share/applications/redshift.desktop \
      --replace 'Exec=redshift' "Exec=$out/bin/redshift"
    substituteInPlace $out/share/applications/redshift-gtk.desktop \
      --replace 'Exec=redshift-gtk' "Exec=$out/bin/redshift-gtk"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Screen color temperature manager";
    longDescription = ''
      Redshift adjusts the color temperature according to the position
      of the sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color temperature
      transitions smoothly from night to daytime temperature to allow
      your eyes to slowly adapt. At night the color temperature should
      be set to match the lamps in your room.
    '';
    license = licenses.gpl3Plus;
    homepage = http://jonls.dk/redshift;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yegortimoshenko globin ];
  };
}
