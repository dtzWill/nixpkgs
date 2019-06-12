{ fetchurl, stdenv, fetchgit
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl
, pythonPackages
, bash-completion
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
}:

with stdenv.lib;

# notmuch no longer supports gmime < 3.0, let's be sure nothing tries to do so
assert (versionAtLeast gmime.version "3.0");

stdenv.mkDerivation rec {
  pname = "notmuch";
  version = "0.29.1";

  passthru = {
    pythonSourceRoot = "${pname}-${version}/bindings/python";
    #pythonSourceRoot = "${src}/bindings/python"; # lol
    inherit version;
  };

  src = fetchgit {
    name = "${pname}-${version}"; # descriptive but exact name, used above in pythonSourceRoot
    url = git://git.notmuchmail.org/git/notmuch;
    #rev = "bc396c967c7cd8e7a109858e428d7bf97173f7a7";
    rev = "refs/tags/${version}";
    sha256 = "0mw3bxmbjc5wwadf7v7vj5zf4i40c9wvschxqklxxg11qy5lhfis";
  };
  #src = fetchurl {
  #  url = "https://notmuchmail.org/releases/${name}.tar.gz";
  #  sha256 = "1v0ff6qqwj42p3n6qw30czzqi52nvgf3dn05vd7a03g39a5js8af";
  #};

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnupg # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    doxygen perl  # (optional) api docs
    pythonPackages.sphinx pythonPackages.python  # (optional) documentation -> doc/INSTALL
    bash-completion  # (optional) dependency to install bash completion
    emacs  # (optional) to byte compile emacs code, also needed for tests
    ruby  # (optional) ruby bindings
  ];

  postPatch = ''
    patchShebangs configure
    patchShebangs test/

    for src in \
      util/crypto.c \
      notmuch-config.c
    do
      substituteInPlace "$src" \
        --replace \"gpg\" \"${gnupg}/bin/gpg\"
    done

    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"
  '';

  configureFlags = [
    "--without-emacs"
    #"--without-docs"
    #"--without-api-docs"
    "--zshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
  ];

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';
  doCheck = !stdenv.hostPlatform.isDarwin && (versionAtLeast gmime.version "3.0");
  checkTarget = "test";
  checkInputs = [
    which dtach openssl bash
    gdb man
  ];

  installTargets = [ "install" "install-man" ];

  dontGzipMan = true; # already compressed

  meta = {
    description = "Mail indexer";
    homepage    = https://notmuchmail.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ flokli garbas the-kenny ];
    platforms   = platforms.unix;
  };
}
