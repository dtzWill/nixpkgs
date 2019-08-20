{ stdenv, fetchurl, substituteAll, openconnect, intltool, pkgconfig, autoreconfHook, networkmanager, gcr, libsecret, file
, gtk3, withGnome ? true, gnome3, kmod }:

let
  pname   = "NetworkManager-openconnect";
  version = "1.2.6";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0nlp290nkawc4wqm978n4vhzg3xdqi8kpjjx19l855vab41rh44m";
  };
  #src = fetchFromGitLab {
  #  domain = "gitlab.gnome.org";
  #  owner = "GNOME";
  #  repo = pname;
  #  rev = "24c2c899e223c5e8ddb8a1159f51aec9090a8b2d";
  #  sha256 = "0jsyilrrxglq2wsypcf0xypa36n789yaar9ib8p26laagmk19nmp";
  #};

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openconnect;
    })
    #./can-persist.patch
    #./0001-Bug-770880-Revamp-certificate-warning-accept-dialog.patch
    #./0001-Bug-770880-Disallow-manual-cert-acceptance.patch
  ];

  buildInputs = [ openconnect networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 gcr libsecret ];

  nativeBuildInputs = [ intltool pkgconfig file ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
    "--without-libnm-glib"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
