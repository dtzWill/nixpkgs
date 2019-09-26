{ vte, fetchFromGitHub, fetchpatch, autoconf, automake, gtk-doc, gettext, libtool, gperf }:

vte.overrideAttrs (oldAttrs: rec {
  name = "vte-ng-${version}";
  pname = "vte-ng"; # fix for override
  version = "0.54.2.a";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "vte-ng";
    rev = version;
    sha256 = "1r7d9m07cpdr4f7rw3yx33hmp4jmsk0dn5byq5wgksb2qjbc4ags";
  };

  # vte-ng doesn't support meson yet, while vte now requires it.
  # Disable until vte-ng supports it.
  dontUseMesonConfigure = true;
  # Similarly, disable ninja
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;

  patches = [
    # Fix build with vala 0.44
    # See: https://github.com/thestinger/vte-ng/issues/32
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/vte/commit/53690d5cee51bdb7c3f7680d3c22b316b1086f2c.patch";
      sha256 = "1jrpqsx5hqa01g7cfqrsns6vz51mwyqwdp43ifcpkhz3wlp5dy66";
    })
  ];

  preConfigure = oldAttrs.preConfigure + "; NOCONFIGURE=1 ./autogen.sh";

  nativeBuildInputs = oldAttrs.nativeBuildInputs or []
    ++ [ gtk-doc autoconf automake gettext libtool gperf ];
})
