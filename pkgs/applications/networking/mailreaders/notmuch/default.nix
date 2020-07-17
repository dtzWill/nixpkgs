{ fetchurl, stdenv
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl, texinfo
, pythonPackages
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
}:

with stdenv.lib;

# notmuch no longer supports gmime < 3.0, let's be sure nothing tries to do so
assert (versionAtLeast gmime.version "3.0");

stdenv.mkDerivation rec {
  pname = "notmuch";
  version = "0.30";

  passthru = {
    pythonSourceRoot = "${pname}-${version}/bindings/python";
    #pythonSourceRoot = "${src}/bindings/python"; # lol
    inherit version;
  };

  ## src = fetchgit {
  ##   name = "${pname}-${version}"; # descriptive but exact name, used above in pythonSourceRoot
  ##   url = git://git.notmuchmail.org/git/notmuch;
  ##   #rev = "bc396c967c7cd8e7a109858e428d7bf97173f7a7";
# ##    rev = "refs/tags/${version}";
  ##   rev = "1fcf068e331b9b79e14f79c8b126711fc3d72cbb";
  ##   sha256 = "1pf9xds5csw6vwkb4b15isrw29psdifx8gl8y61la7d1k7b6m517";
  ## };
  src = fetchurl {
    url = "https://notmuchmail.org/releases/${pname}-${version}.tar.xz";
    sha256 = "1ylnj12f7xr18v3ckb1nwc2aw2rj3ghqnj5f4rzccr8xw5pslfsy";
  };

  nativeBuildInputs = [
    pkgconfig
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
  ] ++ optional withEmacs [ emacs ];
  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
    ruby
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
    "--bashcompletiondir=${placeholder "out"}/share/bash-completion/completions"
    "--infodir=${placeholder "info"}/share/info"
  ] ++ optional (!withEmacs) "--without-emacs"
    ++ optional (withEmacs) "--emacslispdir=${placeholder "emacs"}/share/emacs/site-lisp"
    ++ optional (isNull ruby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];

  outputs = [ "out" "man" "info" ] ++ stdenv.lib.optional withEmacs "emacs";

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
    maintainers = with maintainers; [ flokli the-kenny ];
    platforms   = platforms.unix;
  };
}
