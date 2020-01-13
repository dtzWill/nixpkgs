{ stdenv, fetchFromBitbucket, meson, ninja, pkgconfig, glib }:

stdenv.mkDerivation rec {
  pname = "gplugin";
  version = "0.29.0";

  src = fetchFromBitbucket {
    owner = "gplugin";
    repo = "gplugin";
    rev = "v${version}";
    sha256 = "1111111111111111111111111111111111111111111111111111";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ glib ];
}
