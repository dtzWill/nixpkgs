{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "elfkickers";
  #version = "3.1";
  version = "unstable-2020-02-11";

  src = fetchFromGitHub {
    owner = "BR903";
    repo = pname;
    rev = "e1af22cc152abc9e9c8d28e8011fd39d33e8e3c1";
    sha256 = "0k00jb61h28g3hqzsbxszk1kszlrzv2vzsjxrnwrm41dzcjcmrby";
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
