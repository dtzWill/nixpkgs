{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "pagemon";
  version = "0.01.16";

  src = fetchurl {
    url = "https://kernel.ubuntu.com/~cking/tarballs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "058qllbsgdvhdcyqrwp0xr1hbasfrbbnnzqvbqn47fcck5nc15xp";
  };

  buildInputs = [ ncurses ];

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man8"
  ];

  meta = with stdenv.lib; {
    homepage = "https://kernel.ubuntu.com/~cking/pagemon/";
    description = "Interactive memory/page monitor for Linux";
    longDescription = ''
      pagemon is an ncurses based interactive memory/page monitoring tool
      allowing one to browse the memory map of an active running process
      on Linux.
      pagemon reads the PTEs of a given process and display the soft/dirty
      activity in real time. The tool identifies the type of memory mapping
      a page belongs to, so one can easily scan through memory looking at
      pages of memory belonging data, code, heap, stack, anonymous mappings
      or even swapped-out pages.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
