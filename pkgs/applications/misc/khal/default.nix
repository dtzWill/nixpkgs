{ stdenv, fetchFromGitHub, pkgs, python3, glibcLocales, fetchpatch }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "unstable-2019-10-09";

  SETUPTOOLS_SCM_PRETEND_VERSION = "0.10.1-${version}";
  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "19d8dce4f7a9a6950e851422a7099640dddae2d3";
    sha256 = "0gwsmcyvwmgmhkcjf8j4raz1iyzhwghjrq4qjhqx8qpfmsvjx4px";
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
  nativeBuildInputs = [ setuptools_scm sphinx sphinxcontrib_newsfeed ];
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
  + stdenv.lib.optionalString false ''
    # man page
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
