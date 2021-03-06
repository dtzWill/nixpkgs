{ stdenv, fetchFromGitHub, autoreconfHook, pcre-cpp, sqlite, ncurses
, readline, zlib, bzip2, curl }:

stdenv.mkDerivation rec {

  pname = "lnav";
  inherit (meta) version;

  src = fetchFromGitHub {
    owner = "tstack";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z8bsr0falxlkmd1b5gy871vyafyih0sw7lgg858lqnbsy0q2m4i";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    zlib
    bzip2
    ncurses
    pcre-cpp
    readline
    sqlite
    curl
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tstack/lnav;
    description = "The Logfile Navigator";
    longDescription = ''
      The log file navigator, lnav, is an enhanced log file viewer that takes
      advantage of any semantic information that can be gleaned from the files
      being viewed, such as timestamps and log levels. Using this extra
      semantic information, lnav can do things like interleaving messages from
      different files, generate histograms of messages over time, and providing
      hotkeys for navigating through the file. It is hoped that these features
      will allow the user to quickly and efficiently zero in on problems.
    '';
    downloadPage = "https://github.com/tstack/lnav/releases";
    license = licenses.bsd2;
    version = "0.8.5";
    maintainers = [ maintainers.dochang ];
    platforms = platforms.unix;
  };

}
