{ stdenv, fetchFromGitHub, php, flex, makeWrapper }:

let
  libphutil = fetchFromGitHub rec {
    name = "${repo}-${builtins.substring 0 7 rev}";
    owner = "phacility";
    repo = "libphutil";
    rev = "f51f1b3f72b50246949d0917239ca84f39ec7a54";
    sha256 = "1pffvq9rl5b1gldpzzyv6cvwmcr2f47kfavr9fkrdz63k3i7yan3";
  };
  arcanist = fetchFromGitHub rec {
    name = "${repo}-${builtins.substring 0 7 rev}";
    owner = "phacility";
    repo = "arcanist";
    rev = "3cdfe1fff806d2b54a2df631cf90193e518f42b7";
    sha256 = "1dngq8p4y4hln87hhgdm6hv68ld626j57lifw0821rvpnnmspw6j";
  };
in
stdenv.mkDerivation rec {
  pname    = "arcanist";
  version = "unstable-2019-09-05";

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
