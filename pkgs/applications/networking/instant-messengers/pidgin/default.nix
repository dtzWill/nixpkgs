{ stdenv, fetchurl, makeWrapper, pkgconfig, gtk2, gtk2-x11
, gtkspell2, aspell
, gst_all_1, startupnotification, gettext
, perlPackages, libxml2, nss, nspr, farstream
, libXScrnSaver, ncurses, avahi, dbus, dbus-glib, intltool, libidn
, lib, python, libICE, libXext, libSM
, cyrus_sasl ? null
, openssl ? null
, gnutls ? null
, libgcrypt ? null
, plugins, symlinkJoin
}:

# FIXME: clean the mess around choosing the SSL library (nss by default)

let unwrapped = stdenv.mkDerivation rec {
  name = "pidgin-${version}";
  majorVersion = "2";
  version = "${majorVersion}.14.1";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/${name}.tar.bz2";
    sha256 = "10070r8jp1m3cs8rjrn38rksi4h8yjj9pqncdbjdj5qian6y2cpi";
  };

  inherit nss ncurses;

  nativeBuildInputs = [ makeWrapper ];

  NIX_CFLAGS_COMPILE = "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0";

  buildInputs = [
    aspell startupnotification
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    libxml2 nss nspr
    libXScrnSaver ncurses python
    avahi dbus dbus-glib intltool libidn
    libICE libXext libSM cyrus_sasl
  ]
  ++ (lib.optional (openssl != null) openssl)
  ++ (lib.optional (gnutls != null) gnutls)
  ++ (lib.optional (libgcrypt != null) libgcrypt)
  ++ (lib.optional (stdenv.isLinux) gtk2)
  ++ (lib.optional (stdenv.isLinux) gtkspell2)
  ++ (lib.optional (stdenv.isLinux) farstream)
  ++ (lib.optional (stdenv.isDarwin) gtk2-x11);


  propagatedBuildInputs = [ pkgconfig gettext ]
    ++ (with perlPackages; [ perl XMLParser ])
    ++ (lib.optional (stdenv.isLinux) gtk2)
    ++ (lib.optional (stdenv.isDarwin) gtk2-x11);

  patches = [ ./pidgin-makefile.patch ./add-search-path.patch ];

  configureFlags = [
    "--with-nspr-includes=${nspr.dev}/include/nspr"
    "--with-nspr-libs=${nspr.out}/lib"
    "--with-nss-includes=${nss.dev}/include/nss"
    "--with-nss-libs=${nss.out}/lib"
    "--with-ncurses-headers=${ncurses.dev}/include"
    "--disable-meanwhile"
    "--disable-nm"
    "--disable-tcl"
    "--disable-gtkspell"
    "--disable-vv"
  ]
  ++ (lib.optionals (cyrus_sasl != null) [ "--enable-cyrus-sasl=yes" ])
  ++ (lib.optionals (gnutls != null) ["--enable-gnutls=yes" "--enable-nss=no"]);

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/pidgin \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = with stdenv.lib; {
    description = "Multi-protocol instant messaging client";
    homepage = http://pidgin.im;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
};

in if plugins == [] then unwrapped
    else import ./wrapper.nix {
      inherit makeWrapper symlinkJoin plugins;
      pidgin = unwrapped;
    }
