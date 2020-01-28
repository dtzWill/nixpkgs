{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub rec {
    name = "${repo}-${builtins.substring 0 7 rev}";
    owner = "phacility";
    repo = "libphutil";
    rev = "cc2a3dbf590389400da55563cb6993f321ec6d73";
    sha256 = "1k7sr3racwz845i7r5kdwvgqrz8gldz07pxj3yw77s58rqbix3ad";
  };
  arcanist = fetchFromGitHub rec {
    name = "${repo}-${builtins.substring 0 7 rev}";
    owner = "phacility";
    repo = "arcanist";
    rev = "21a1828ea06cf031e93082db8664d73efc88290a";
    sha256 = "05rq9l9z7446ks270viay57r5ibx702b5bnlf4ck529zc4abympx";
  };
in
stdenv.mkDerivation {
  pname = "arcanist";
  version = "20200127";

  srcs = [ arcanist libphutil ];
  sourceRoot = ".";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ php flex ];

  #unpackPhase = ''
  #  cp -aR ${libphutil} libphutil
  #  cp -aR ${arcanist} arcanist
  #  chmod +w -R libphutil arcanist
  #'';

  postPatch = stdenv.lib.optionalString stdenv.isAarch64 ''
    substituteInPlace libphutil*/support/xhpast/Makefile \
      --replace "-minline-all-stringops" ""
  '';

  makeFlags = [
    "-C" "${libphutil.name}/support/xhpast"
  ];
  buildFlags = [
    "clean"
    "all"
    "install"
  ];
  installPhase = ''
    mkdir -p $out/{bin,libexec}
    mv ${libphutil.name} $out/libexec/libphutil
    # TODO: symlink to store ?
    mv ${arcanist.name} $out/libexec/arcanist

    makeWrapper $out/libexec/arcanist/bin/arc $out/bin/arc \
      --prefix PATH : "${php}/bin"
  '';

  meta = {
    description = "Command line interface to Phabricator";
    homepage    = "http://phabricator.org";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
