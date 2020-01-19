{ stdenv, fetchFromGitHub, pkgconfig, pidgin, json-glib, glib, http-parser, sqlite, olm, libgcrypt } :

stdenv.mkDerivation rec {
  pname = "purple-matrix-unstable";
  version = "2019-12-28";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "purple-matrix";
    rev = "1d23385e6c22f63591fcbfc85c09999953c388ed";
    sha256 = "18ghdhn7m3jzp5zgyggip70icdn01wdvkin8vm915v79jc0xcxh7";
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
