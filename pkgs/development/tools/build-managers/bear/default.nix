{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  pname = "bear";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = pname;
    rev = version;
    sha256 = "19fk4flfykbzhb89ppmzqf0zlrkbjm6ajl9fsayndj9km5ys0041";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ]; # just for shebang of bin/bear

  doCheck = false; # all fail

  patches = [ ./ignore_wrapper.patch ./cmakepaths.patch ];

  meta = with stdenv.lib; {
    description = "Tool that generates a compilation database for clang tooling";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = https://github.com/rizsotto/Bear;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.babariviere ];
  };
}
