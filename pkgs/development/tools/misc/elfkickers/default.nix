{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  #version = "3.1";
  version = "unstable-2020-02-18";

  src = fetchFromGitHub {
    owner = "BR903";
    repo = pname;
    rev = "dbeb4972ec3bddd1163608b7958e267cec594664";
    sha256 = "01s3mkgsb3cikxqwlgpwdwgypmiphbm86xhkw6lfd179d1g6vihv";
  };
  #src = fetchurl {
  #  url = "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-${version}.tar.gz";
  #  sha256 = "0n0sypjrdm3ramv0sby4sdh3i3j9d0ihadr951wa08ypdnq3yrkd";
  #};

  makeFlags = [ "CC=cc" "prefix=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = http://www.muppetlabs.com/~breadbox/software/elfkickers.html;
    description = "A collection of programs that access and manipulate ELF files";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.dtzWill ];
  };
}
