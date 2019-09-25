{ stdenv, fetchFromGitHub, pkgs, python3, glibcLocales, fetchpatch }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "pim-utils";
    repo = pname;
    rev = "1f93d238fec7c934dd2f8e48f54925d22130e3aa";
    sha256 = "1111111111111111111111111111111111111111111111111111";
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
