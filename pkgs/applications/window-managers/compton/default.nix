{ stdenv, lib, fetchFromGitHub, pkgconfig, uthash, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja
, xorgproto, libxcb ,xcbutilrenderutil, xcbutilimage, pixman, libev
, dbus, libconfig, libdrm, libGL, pcre, libX11
, libXinerama, libXext, xwininfo, libxdg_basedir }:
stdenv.mkDerivation rec {
  pname = "compton";
  #version = "7.3";
  version = "2019-09-16";

  COMPTON_VERSION = "v${version}";

  src = fetchFromGitHub {
    owner  = "yshui";
    repo   = "compton";
    #rev    = COMPTON_VERSION;
    rev = "de5d5ca9bb3aa4a6c47d4ff180377eb02440dae6";
    sha256 = "04r8hmwib97q3yabm0f3m7hi1ac0i3grhghykw5189bh5b7swz24";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    meson ninja
    pkgconfig
    uthash
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    makeWrapper
  ];

  buildInputs = [
    dbus libX11 libXext
    xorgproto
    libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    libxcb xcbutilrenderutil xcbutilimage
    pixman libev
    libxdg_basedir
    # TODO: upstream, check if still needed
    uthash
  ];

    NIX_CFLAGS_COMPILE = [
      "-fno-strict-aliasing"
      # These control some verbose debugging info
      # useful should anything go wrong but not suitable
      # for regular use.
      #"-DDEBUG_RESTACK=1"
      #"-DDEBUG_EVENTS=1"
    ];

  # This doesn't help anymore, IIRC, TODO: check and report to nixpkgs master
  ##preBuild = ''
  ##  git() { echo "v${version}"; }
  ##  export -f git
  ##'';

  doCheck = true;

  mesonFlags = [
    "-Dbuild_docs=true"
    "-Dunittest=true"
    # Optional, I prefer to leave it on for sanity's sake
#    "-Dsanitize=true"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/compton-trans \
      --prefix PATH : ${lib.makeBinPath [ xwininfo ]}
  '';

  meta = with lib; {
    description = "A fork of XCompMgr, a sample compositing manager for X servers";
    longDescription = ''
      A fork of XCompMgr, which is a sample compositing manager for X
      servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
      extensions. It enables basic eye-candy effects. This fork adds
      additional features, such as additional effects, and a fork at a
      well-defined and proper place.
    '';
    license = licenses.mit;
    homepage = "https://github.com/yshui/compton";
    maintainers = with maintainers; [ ertes enzime twey ];
    platforms = platforms.linux;
  };
}
