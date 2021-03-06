{ stdenv, fetchFromGitLab, fetchurl, substituteAll, autoreconfHook, iodine, intltool, pkgconfig, networkmanager, libsecret, gtk3
, withGnome ? true, gnome3, fetchpatch, libnma }:

let
  pname = "NetworkManager-iodine";
  version = "1.2.0";
in stdenv.mkDerivation {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0njdigakidji6mfmbsp8lfi8wl88z1dk8cljbva2w0xazyddbwyh";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit iodine;
    })
  ];

  buildInputs = [ iodine networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 libsecret libnma ];

  nativeBuildInputs = [ intltool pkgconfig ];

  # Fixes deprecation errors with networkmanager 1.10.2, glib 2.62.0
  NIX_CFLAGS_COMPILE = [ "-Wno-deprecated-declarations" "-Wno-error" ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-iodine";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
