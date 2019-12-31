{ stdenv, fetchurl, fetchFromGitHub, ncurses, gettext, python3, python3Packages
, makeWrapper, autoreconfHook, asciidoc-full, libxml2, tzdata }:

stdenv.mkDerivation rec {
  pname = "calcurse";
  #version = "4.5.1";
  version = "unstable-2019-12-29";

  src = fetchFromGitHub {
    owner = "lfos";
    repo = pname;
    rev = "002cf305a59d311d1dc3806009ecae90a5d9be38";
    sha256 = "1haffbdaghlzjhdfdzq3n2adcj4c5njim27amqwnc4djy8mz8xbv";
  };
  #src = fetchurl {
  #  #url = "https://calcurse.org/files/${pname}-${version}.tar.gz";
  #  sha256 = "0vw2xi6a2lrhrb8n55zq9lv4mzxhby4xdf3hmi1vlfpyrpdwkjzd";
  #};

  ## #version = "4.4.0";
  ## version = "2019-06-10";

  #src = fetchFromGitHub {
  #  owner = "lfos";
  #  repo = pname;
  #  rev = "04904048a02ad60ad91eb36f8d1812236c2fa013";
  #  sha256 = "0n3854ha4bzmddwbml620ncncnpp0w2n83qqv2wzljkrdp42rcbf";
  #};

  # I guess vdirsyncer bits dropped in 4.5.0? or changed?
  # Anyway dropping this for now since I'm caving and using caldav instead, maybe.
  #patches = [ ./vdirsyncer-quoting.patch ];

  buildInputs = [ ncurses gettext python3 python3Packages.wrapPython ];
  nativeBuildInputs = [ makeWrapper autoreconfHook asciidoc-full libxml2.bin ];

  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  doCheck = true;

  # libxml2 oauth2client
  postInstall = ''
    patchShebangs .
    buildPythonPath ${python3Packages.httplib2}
    patchPythonScript $out/bin/calcurse-caldav
    install -Dm755 contrib/vdir/calcurse-vdirsyncer $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A calendar and scheduling application for the command line";
    longDescription = ''
      calcurse is a calendar and scheduling application for the command line. It helps
      keep track of events, appointments and everyday tasks. A configurable notification
      system reminds users of upcoming deadlines, the curses based interface can be
      customized to suit user needs and a very powerful set of command line options can
      be used to filter and format appointments, making it suitable for use in scripts.
    '';
    homepage = http://calcurse.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
