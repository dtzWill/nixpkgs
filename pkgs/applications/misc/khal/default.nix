{ stdenv, fetchFromGitHub, pkgs, python3, glibcLocales, fetchpatch }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "unstable-2019-11-09";

  SETUPTOOLS_SCM_PRETEND_VERSION = "0.10.1-${version}";
  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "ed31553b1fb18d28779dd63e8fd11e3e54218027";
    sha256 = "1dn4y90z2pzrskdvrknyavlksn1wm97n1ki3xi7fhbgd18nw4vih";
  };

  propagatedBuildInputs = [
    atomicwrites
    click
    click-log
    configobj
    dateutil
    icalendar
    lxml
    pkgs.vdirsyncer
    pytz
    pyxdg
    requests_toolbelt
    tzlocal
    urwid
    pkginfo
    freezegun
    pkgs.shadow
  ];
  nativeBuildInputs = [
    setuptools_scm
    #(pkgs.buildEnv {
    #  name = "sphinx-env";
    #  paths = [ (python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])) ];
    #})
    #("${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])}/bin/sphinx-build")
    #(sphinx.overrideAttrs(o: {
    #  propagatedBuildInputs = o.propagatedBuildInputs or [] ++ [ sphinxcontrib_newsfeed ];
    #}))
    #sphinx
  ];
  checkInputs = [ pytest glibcLocales /* :( */ ];

  patches = [
    ./no-dev-tty-is-okay.patch
  ];

  postInstall = ''
    # zsh completion
    install -D misc/__khal $out/share/zsh/site-functions/__khal
  ''
  # Punt on man page for now :(...
  # sphinx isn't able to find sphinxcontrib_newsfeed
  # and only fix I found so far is to bundle together in python.withPackages.
  # Unfortunately that build fails later on, due to dup dependencies apparently.
  # Oh well.
  # XXX: Maybe it'd work if built entirely separately? (and linked back in)
  # Oh hey, the following kludgetasmadoodle does the job:
  + stdenv.lib.optionalString true ''
    # man page
    PATH="${python3.withPackages (ps: with ps; [ sphinx sphinxcontrib_newsfeed ])}/bin:$PATH" \
    make -C doc man
    install -Dm755 doc/build/man/khal.1 -t $out/share/man/man1
  '' + ''
    # desktop
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  checkPhase = ''
    export LC_ALL=C.UTF-8
    export HOME=$PWD/tmp
    mkdir -p $HOME
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
