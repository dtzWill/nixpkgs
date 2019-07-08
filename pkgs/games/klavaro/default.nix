{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3 }:

stdenv.mkDerivation rec {
  name = "klavaro-${version}";
  version = "3.09";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "12gml7h45b1w9s318h0d5wxw92h7pgajn2kh57j0ak9saq0yb0wr";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "Just another free touch typing tutor program";
    homepage = http://klavaro.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.mimadrid];
  };
}
