{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  #version = "3.1";
  version = "unstable-2019-11-22";

  src = fetchFromGitHub {
    owner = "BR903";
    repo = pname;
    rev = "2c90cd821f29af3a6e2a658474789b106923476c";
    sha256 = "1733czjpivnr15xd58nmdl7vy69v2mv32kqis8ivb0xl96m2q96s";
  };
  #src = fetchurl {
  #  url = "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
  #  sha256 = "0n0sypjrdm3ramv0sby4sdh3i3j9d0ihadr951wa08ypdnq3yrkd";
  #};

  makeFlags = [ "CC=cc" "prefix=${placeholder "out"}" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.muppetlabs.com/~breadbox/software/elfkickers.html;
    description = "A collection of programs that access and manipulate ELF files";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.dtzWill ];
  };
}
