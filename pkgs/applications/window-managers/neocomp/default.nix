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
  version = "unstable-2020-01-01";

  src = fetchFromGitHub {
    owner  = "DelusionalLogic";
    repo   = name;
    rev = "3ba648076dbc78cf6927bf797d1e9e389e27bd92";
    sha256 = "04bgw1z95xz4nnry91hzsgil9mg9ydcwi41bkfhk5c4xrjmlx689";
  };

  nativeBuildInputs = [
    pkgconfig
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
  ];

  buildInputs = xdeps ++ [
    freetype
    judy
    libGL
    libconfig
    libdrm
    libxml2
    libxslt
    pcre
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
