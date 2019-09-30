{ stdenv, fetchurl, fetchFromGitLab, substituteAll, openconnect, intltool, pkgconfig, autoreconfHook, networkmanager, gcr, libsecret, file
, gtk3, withGnome ? true, gnome3, kmod }:

let
  pname   = "NetworkManager-openconnect";
  version = "1.2.7-dev-9"; # 2019-09-25
in stdenv.mkDerivation {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  #src = fetchurl {
  #  url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
  #  sha256 = "0nlp290nkawc4wqm978n4vhzg3xdqi8kpjjx19l855vab41rh44m";
  #};
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "de44e42509d85c0ce94492441b5aa70a90d186fb";
    sha256 = "1n044w9793m95nml3va1dnwg23y82lwga4mz2g9i8b4jr64ijqpw";
  };

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
