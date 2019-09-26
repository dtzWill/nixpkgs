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
    rev = "17ec95577a60f5da3fd9bd5af5960d344ce39950";
    sha256 = "13lcq63v45dwayxgd6iyyxaxvr9fcs6j073y0q18ygwwxhmfpi82";
  };

  postPatch = ''
    sed -i -e '23i#include <limits.h>' util.c
    sed -i -e '9i#include <limits.h>' b64.c
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
