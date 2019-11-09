{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, intltool, pkgconfig, python
, networkmanager, ppp, sstp
, gtk3, libsecret, libnma }:

stdenv.mkDerivation rec {
  pname = "network-manager-sstp";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "enaess";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0dbd5zgf48zr9ln97pg7nlcms6y6zfq0krx07k5lrpqrlhcyg7ip";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit ppp sstp;
    })
  ];

  nativeBuildInputs= [ autoreconfHook intltool pkgconfig python ];
  buildInputs = [
    networkmanager ppp sstp
    gtk3 libsecret libnma
  ];

  preAutoreconf = ''
    intltoolize --force
  '';

  configureFlags = [
    "--without-libnm-glib"
    "--enable-absolute-paths"
  ];

}
