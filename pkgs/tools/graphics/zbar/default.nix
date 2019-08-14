{ stdenv, fetchFromGitHub, imagemagickBig, pkgconfig, python2Packages, perl
, libX11, libv4l, qt5, gtk3, xmlto, docbook_xsl, autoreconfHook, dbus
, enableVideo ? stdenv.isLinux, enableDbus ? stdenv.isLinux
, enablePyGTK ? false # legacy
}:

with stdenv.lib;
let
  inherit (python2Packages) pygtk python;
in stdenv.mkDerivation rec {
  pname = "zbar";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "zbar";
    rev = version;
    sha256 = "0hlxakpyjg4q9hp7yp3har1n78341b4knwyll28hn48vykg28pza";
  };

  nativeBuildInputs = [ pkgconfig xmlto autoreconfHook docbook_xsl ];

  buildInputs = [
    imagemagickBig perl libX11
    # make this optional, python3?
    python
  ] ++ optional enableDbus dbus
  ++ optionals enableVideo [
    libv4l gtk3 qt5.qtbase qt5.qtx11extras
  ] ++ optionals enablePyGTK [ python pygtk ];

  configureFlags = (if enableDbus then [
    "--with-dbusconfdir=$out/etc/dbus-1/system.d"
  ] else [ "--without-dbus" ])
  ++ (if (!enableVideo) then [
    "--disable-video" "--without-gtk" "--without-qt"
  ] else [ "--with-gtk=auto" ]);

  postInstall = optionalString enableDbus ''
    install -Dm644 dbus/org.linuxtv.Zbar.conf $out/etc/dbus-1/system.d/org.linuxtv.Zbar.conf
  '';

  meta = with stdenv.lib; {
    description = "Bar code reader";
    longDescription = ''
      ZBar is an open source software suite for reading bar codes from various
      sources, such as video streams, image files and raw intensity sensors. It
      supports many popular symbologies (types of bar codes) including
      EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR
      Code.
    '';
    maintainers = with maintainers; [ delroth raskin ];
    platforms = platforms.unix;
    license = licenses.lgpl21;
    homepage = https://github.com/mchehab/zbar;
  };
}
