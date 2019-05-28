{ stdenv
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
, xlibs
}:
let
  date  = "2019-05-25";
  rev   = "v0.6-22-g2970336";
  xdeps = with xlibs; [
    libXcomposite libXdamage libXrender libXext libXrandr libXinerama
  ];
in
stdenv.mkDerivation rec {
  name    = "NeoComp";
  version = "git-${rev}-${date}";

  src = fetchFromGitHub {
    inherit rev;
    owner  = "DelusionalLogic";
    repo   = name;
    sha256 = "0ilprs56mqw4y5xdpi0c4xnimmjd2xgv4zi55qw6z52yv6k3m15n";
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
