{ stdenv, fetchurl, perl, python2, ruby, bison, gperf, cmake, ninja
, pkgconfig, gettext, gobject-introspection, libnotify, gnutls, libgcrypt
, gtk3, wayland, libwebp, enchant2, xorg, libxkbcommon, epoxy, dbus, at-spi2-core
, libxml2, libsoup, libsecret, libxslt, harfbuzz, libpthreadstubs, pcre, nettle, libtasn1, p11-kit
, libidn, libedit, readline, libGL, libGLU, libintl, openjpeg
, enableGeoLocation ? true, geoclue2, sqlite
, enableGtk2Plugins ? false, gtk2 ? null
, gst-plugins-base, gst-plugins-bad, woff2
#, libwpe, wpebackend-fdo
, bubblewrap, libseccomp, xdg-dbus-proxy
, substituteAll
}:

assert enableGeoLocation -> geoclue2 != null;
assert enableGtk2Plugins -> gtk2 != null;
assert stdenv.isDarwin -> !enableGtk2Plugins;

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "webkitgtk";
  version = "2.28.1";

  meta = {
    description = "Web content rendering engine, GTK port";
    homepage = https://webkitgtk.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    hydraPlatforms = [];
    maintainers = with maintainers; [ ];
  };

  src = fetchurl {
    url = "https://webkitgtk.org/releases/${pname}-${version}.tar.xz";
    sha256 = "rLwmo+1cE/OeRodc9EepwFQbbPsX+eeIQyNDHLMn89g=";
  };

  patches = optionals stdenv.isLinux [
    (substituteAll {
      src = ./fix-bubblewrap-paths.patch;
      inherit (builtins) storeDir;
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  #NIX_CFLAGS_COMPILE = [ "-O2" "-pipe" ]
  #  ++ optionals stdenv.cc.isClang [
  #  # be a bit quieter, save time+logs
  #  "-Wno-string-plus-int"
  #  # don't bother generating colorful diagrams for warnings :)
  #  "-fno-color-diagnostics"
  #  # bit less debug
  #  "-g0"
  #];

  cmakeFlags = [
  "-DPORT=GTK"
  "-DUSE_LIBHYPHEN=OFF"
  "-DENABLE_INTROSPECTION=ON"
  # XXX: until wpebackend-fdo is un-broken
  "-DUSE_WPE_RENDERER=OFF"
  ]
  ++ optional (!enableGtk2Plugins) "-DENABLE_PLUGIN_PROCESS_GTK2=OFF"
  ++ optional stdenv.isLinux "-DENABLE_GLES2=ON"
  # Apparently build is much too brittle for any of this (?!)
  #++ optionals stdenv.isLinux [
  #  "-DENABLE_GLES2=OFF"
  #  "-DENABLE_OPENGL=ON"
  #  "-DENABLE_WEBGL=ON"
  #  "-DENABLE_ACCELERATED_2D_CANVAS=ON"

  #  "-DDEVELOPER_MODE=OFF"
  #  "-DENABLE_DEVELOPER_MODE=OFF"
  #  # Source/cmake/OptionsCommon.cmake
  #  "-DUSE_LD_GOLD=ON"
  #]
  ++ optionals stdenv.isDarwin [
  "-DUSE_SYSTEM_MALLOC=ON"
  "-DUSE_ACCELERATE=0"
  "-DENABLE_MINIBROWSER=OFF"
  "-DENABLE_VIDEO=ON"
  "-DENABLE_QUARTZ_TARGET=ON"
  "-DENABLE_X11_TARGET=OFF"
  "-DENABLE_OPENGL=OFF"
  "-DENABLE_WEB_AUDIO=OFF"
  "-DENABLE_WEBGL=OFF"
  "-DENABLE_GRAPHICS_CONTEXT_3D=OFF"
  "-DENABLE_GTKDOC=OFF"
  ];

  nativeBuildInputs = [
    cmake ninja perl python2 ruby bison gperf
    pkgconfig gettext gobject-introspection
  ];

  buildInputs = [
    libintl libwebp enchant2 libnotify gnutls pcre nettle libidn libgcrypt woff2
    libxml2 libsecret libxslt harfbuzz libpthreadstubs libtasn1 p11-kit openjpeg
    sqlite gst-plugins-base gst-plugins-bad libxkbcommon epoxy dbus at-spi2-core
    #libwpe wpebackend-fdo
    libGL libGLU
  ] ++ optional enableGeoLocation geoclue2
    ++ optional enableGtk2Plugins gtk2
    ++ (with xorg; [ libXdmcp libXt libXtst libXdamage libXcomposite libXrender  ])
    ++ optionals stdenv.isDarwin [ libedit readline libGLU_combined ]
    ++ optionals stdenv.isLinux [
      wayland bubblewrap libseccomp xdg-dbus-proxy
  ];

  propagatedBuildInputs = [
    libsoup gtk3
  ];

  outputs = [ "out" "dev" ];
}
