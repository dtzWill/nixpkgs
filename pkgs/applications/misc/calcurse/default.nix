{ stdenv, fetchurl, fetchFromGitHub, ncurses, gettext, python3, python3Packages
, makeWrapper, autoreconfHook, asciidoc-full, libxml2, tzdata }:

stdenv.mkDerivation rec {
  pname = "calcurse";
  #version = "4.4.0";
  version = "2019-05-08-multi";

  src = fetchFromGitHub {
    owner = "lfos";
    repo = pname;
    rev = "7425ef982205d24eaaf1a5cfc0e7071d4f36ffb8";
    sha256 = "1dh7l2j5k68q896m9ylkn6vnbn15fh3vf3l7wlki0l8d77b4iwkw";
  };
  #src = fetchurl {
  #  #url = "https://calcurse.org/files/${pname}-${version}.tar.gz";
  #  sha256 = "0vw2xi6a2lrhrb8n55zq9lv4mzxhby4xdf3hmi1vlfpyrpdwkjzd";
  #};

  patches = [ ./vdirsyncer-quoting.patch ];

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
