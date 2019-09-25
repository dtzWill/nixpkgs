{ stdenv, fetchFromGitHub, pkgs, python3, glibcLocales, fetchpatch }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "unstable-2019-09-16";

  src = fetchFromGitHub {
    owner = "pimutils";
    repo = pname;
    rev = "c4f5cd7248abb08a65dbb337bfe5e7e57e2e4a4d";
    sha256 = "09p0cr7x7gy6lwf3kvc90abzwvlqv9a7j47nbk5j6312n23rdz6w";
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

  postInstall = ''
    # zsh completion
    install -D misc/__khal $out/share/zsh/site-functions/__khal

    # man page
    make -C doc man
    install -Dm755 doc/build/man/khal.1 -t $out/share/man/man1

    # desktop
    install -Dm755 misc/khal.desktop -t $out/share/applications
  '';

  doCheck = !stdenv.isAarch64;

  checkPhase = ''
    export LC_ALL=C.UTF-8
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://lostpackets.de/khal/;
    description = "CLI calendar application";
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
