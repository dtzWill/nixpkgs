{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json-glib, glib, http-parser, sqlite, olm, libgcrypt } :

stdenv.mkDerivation rec {
  pname = "purple-matrix-unstable";
  version = "2019-06-06";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "purple-matrix";
    rev = "4494ba22b479917f0b1f96a3019792d3d75bcff1";
    sha256 = "1gjm0z4wa5vi9x1xk43rany5pffrwg958n180ahdj9a7sa8a4hpm";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pidgin json-glib glib http-parser sqlite olm libgcrypt ];

  # Drop bad CFLAGS
  postPatch = ''
    substituteInPlace Makefile.common --replace "-O0 -Werror" ""
  '';

  makeFlags = [
    "PLUGIN_DIR_PURPLE=${placeholder "out"}/lib/purple-2"
    "DATA_ROOT_DIR_PURPLE=${placeholder "out"}/share"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/matrix-org/purple-matrix;
    description = "Matrix support for Pidgin / libpurple";
    license = licenses.gpl2;
    maintainers = with maintainers; [ symphorien ];
  };
}
