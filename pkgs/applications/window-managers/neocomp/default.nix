{
  stdenv
, fetchFromGitHub
, asciidoc
, docbook_xml_dtd_45
, docbook_xsl
, freetype
, judy
, libGL
, libconfig
, libdrm
, libxml2
, libxslt
, pcre
, pkgconfig
, xorg
}:
let
  xdeps = with xorg; [
    libXcomposite libXdamage libXrender libXext libXrandr libXinerama
  ];
in
stdenv.mkDerivation rec {
  name    = "NeoComp";
  version = "unstable-2019-11-01";

  src = fetchFromGitHub {
    owner  = "DelusionalLogic";
    repo   = name;
    rev = "ba1a02fa095aefacd4e35f8f91fc3c4bdd7ebd14";
    sha256 = "183bnrly62rqnjwdb0x15gp7g2fykcnwimhgzlzfyvpv8adbzwby";
  };

  buildInputs = xdeps ++ [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    freetype
    judy
    libGL
    libconfig
    libdrm
    libxml2
    libxslt
    pcre
    pkgconfig
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CFGDIR=${placeholder "out"}/etc/xdg/neocomp"
    "ASTDIR=${placeholder "out"}/share/neocomp/assets"
    "COMPTON_VERSION=${version}"
  ];

  postPatch = ''
    substituteInPlace src/compton.c --replace \
      'assets_add_path("./assets/");' \
      'assets_add_path("${placeholder "out"}/share/neocomp/assets/");'
    substituteInPlace src/assets/assets.c --replace \
      '#define MAX_PATH_LENGTH 64' \
      '#define MAX_PATH_LENGTH 128'
  '';

  meta = with stdenv.lib; {
    homepage        = https://github.com/DelusionalLogic/NeoComp;
    license         = licenses.gpl3;
    maintainers     = with maintainers; [ twey ];
    platforms       = platforms.linux;
    description     = "A fork of Compton, a compositor for X11";
    longDescription = ''
      NeoComp is a (hopefully) fast and (hopefully) simple compositor
      for X11, focused on delivering frames from the window to the
      framebuffer as quickly as possible.
    '';
  };
}
