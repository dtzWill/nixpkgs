{ stdenv, fetchFromGitHub, fetchpatch, cmake, pkgconfig, pcre, libxkbcommon, epoxy
, gtk3, poppler, freetype, libpthreadstubs, libXdmcp, libxshmfence, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.2.0";
  name = "apvlv-${version}";

  src = fetchFromGitHub {
    owner = "naihe2010";
    repo = "apvlv";
    rev = "v${version}";
    sha256 = "0lnp7kp2b44d6frj7hfdkhj6njy2mp6kn98gccv2v441gmj5lx9y";
  };

  NIX_CFLAGS_COMPILE = "-I${poppler.dev}/include/poppler";

  nativeBuildInputs = [
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    cmake
    poppler pcre libxkbcommon epoxy
    freetype gtk3
    libpthreadstubs libXdmcp libxshmfence # otherwise warnings in compilation
  ];

  installPhase = ''
    # binary
    mkdir -p $out/bin
    cp src/apvlv $out/bin/apvlv

    # displays pdfStartup.pdf as default pdf entry
    mkdir -p $out/share/doc/apvlv/
    cp ../Startup.pdf $out/share/doc/apvlv/Startup.pdf
    cp ../main_menubar.glade $out/share/doc/apvlv/main_menubar.glade
  ''
  + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    install -D ../apvlv.desktop $out/share/applications/apvlv.desktop
  '';

  meta = with stdenv.lib; {
    homepage = http://naihe2010.github.io/apvlv/;
    description = "PDF viewer with Vim-like behaviour";
    longDescription = ''
      apvlv is a PDF/DJVU/UMD/TXT Viewer Under Linux/WIN32
      with Vim-like behaviour.
    '';

    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.ardumont ];
  };

}
