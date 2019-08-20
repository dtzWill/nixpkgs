{ stdenv, pkgs, python3, glibcLocales }:

with python3.pkgs; buildPythonApplication rec {
  pname = "khal";
  version = "0.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r8bkgjwkh7i8ygvsv51h1cnax50sb183vafg66x5snxf3dgjl6l";
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
