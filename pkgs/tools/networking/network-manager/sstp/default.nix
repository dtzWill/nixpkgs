{ stdenv, fetchFromGitHub, substituteAll, autoreconfHook, intltool, pkgconfig, python
, networkmanager, ppp, sstp
, gtk3, libsecret, libnma }:

stdenv.mkDerivation rec {
  pname = "network-manager-sstp";
  version = "unstable-2020-02-02";

  src = fetchFromGitHub {
    owner = "enaess";
    repo = pname;
    # rev = "release-${version}";
    rev = "03bf25767a4d24d1867b91f3cc655c9821703260";
    sha256 = "04i0sg6np8vraz1g4vvdbkvgs0dm1phywsvyxi613zc8m58arkzq";
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
