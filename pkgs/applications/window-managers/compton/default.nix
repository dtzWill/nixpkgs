{ stdenv, lib, fetchFromGitHub, pkgconfig, asciidoc, docbook_xml_dtd_45
, docbook_xsl, libxslt, libxml2, makeWrapper, meson, ninja, uthash
, xorgproto, libxcb ,xcbutilrenderutil, xcbutilimage, pixman, libev
, dbus, libconfig, libdrm, libGL, pcre, libX11, libXcomposite, libXdamage
, libXinerama, libXrandr, libXrender, libXext, xwininfo, libxdg_basedir }:

let
  common = source: stdenv.mkDerivation (source // rec {
    name = "${source.pname}-${source.version}";

    nativeBuildInputs = (source.nativeBuildInputs or []) ++ [
      pkgconfig
      asciidoc
      docbook_xml_dtd_45
      docbook_xsl
      makeWrapper
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
      maintainers = with maintainers; [ ertes enzime twey ];
      platforms = platforms.linux;
    };
  });

  stableSource = rec {
    pname = "compton";
    version = "0.1_beta2.5";

    COMPTON_VERSION = version;

    buildInputs = [
      dbus libX11 libXcomposite libXdamage libXrender libXrandr libXext
      libXinerama libdrm pcre libxml2 libxslt libconfig libGL
    ];

    src = fetchFromGitHub {
      owner = "chjj";
      repo = "compton";
      rev = "b7f43ee67a1d2d08239a2eb67b7f50fe51a592a8";
      sha256 = "1p7ayzvm3c63q42na5frznq3rlr1lby2pdgbvzm1zl07wagqss18";
    };

    meta = {
      homepage = https://github.com/chjj/compton/;
    };
  };

  gitSource = rec {
    pname = "compton-git";
#    version = "5.1";
    version = "2019-05-22";
    #version = "6.2";

    COMPTON_VERSION = "v${version}";

    nativeBuildInputs = [ meson ninja ];

    #src = fetchGit /home/will/src/all/compton-yshui;
    src = fetchFromGitHub {
      owner  = "yshui";
      #owner  = "dtzWill";
      repo   = "compton";
      #rev    = COMPTON_VERSION;
      #rev    = "36f6303c792fb35dbf4767d0d2eb6af85b478afe"; # alpha-glx
      rev    = "094f00a048f5d486cc0a17b9dd84e63eb6120ab5"; # next
      sha256 = "1yvhr6z83n50lm58sfk9425ry2saqisj6zdiyqrbxbcn7kpssl0p";
      fetchSubmodules = true;
    };

    buildInputs = [
      dbus libX11 libXext
      xorgproto
      libXinerama pcre libxml2 libxslt libconfig libGL
      # Removed:
      # libXcomposite libXdamage libXrender libXrandr

      # New:
      libxcb xcbutilrenderutil xcbutilimage
      pixman libev
      libxdg_basedir

      uthash
    ];

    postPatch = ''
      substituteInPlace meson.build --replace "version: '6'" "version: '6-git-${version}'"
    '';

    #patches = [ ./logging.patch ./above_sibling.patch ./minor-int-cast-fix.patch ];

    NIX_CFLAGS_COMPILE = [
      "-fno-strict-aliasing"
      #"-DDEBUG_RESTACK=1"
      #"-DDEBUG_EVENTS=1"
    ];

    doCheck = true;

    mesonFlags = [
      "-Dbuild_docs=true"
      "-Dunittest=true"
      "-Dsanitize=true"
    ];

    meta = {
      homepage = https://github.com/yshui/compton/;
    };
  };
in {
  compton-old = common stableSource;
  compton-git = common gitSource;
}
