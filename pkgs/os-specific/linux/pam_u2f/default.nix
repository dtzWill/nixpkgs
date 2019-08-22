{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig, libfido2, pam, asciidoc-full, libxslt, gengetopt }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "1.0.9-git";

  #src     = fetchurl {
  #  url = "https://developers.yubico.com/pam-u2f/Releases/${name}.tar.gz";
  #  sha256 = "16awjzx348imjz141fzzldy00qpdmw2g37rnq430w5mnzak078jj";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "pam-u2f";
    rev = "35bc006635370522e09685b06b709c8cd6b0ccf2";
    sha256 = "1hfnh0rhqk96r4x7ac2qlavjpygmjkynnqag84s8bis6s52d0lcm";
  };

  postPatch = ''
    sed -i -e '23i#include <limits.h>' util.c
    sed -i -e '9i#include <limits.h>' b64.c

    substituteInPlace Makefile.am \
      --replace "-DDEBUG_PAM" "" \
      --replace "-DPAM_DEBUG" ""
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc-full libxslt gengetopt ];
  buildInputs = [ libfido2 pam ];

  configureFlags = [
    "--with-pam-dir=${placeholder "out"}/lib/security"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/pam-u2f/;
    description = "A PAM module for allowing authentication with a U2F device";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ philandstuff ];
  };
}
