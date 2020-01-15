{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig, libfido2, libressl, pam, asciidoc-full, libxslt, gengetopt }:

stdenv.mkDerivation rec {
  pname = "pam_u2f";
  version = "unstable-2019-12-28";

  #src     = fetchurl {
  #  url = "https://developers.yubico.com/pam-u2f/Releases/${name}.tar.gz";
  #  sha256 = "16awjzx348imjz141fzzldy00qpdmw2g37rnq430w5mnzak078jj";
  #};
  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "pam-u2f";
    rev = "7a96961021c8a1596df9b3d0fe34529ffccc0ac2";
    sha256 = "0wgysqy44khmcbzx95p25ypw41xnl956r4rq9r5gdkfbgkz9914p";
  };

  postPatch = ''
    sed -i -e '23i#include <limits.h>' util.c
    sed -i -e '9i#include <limits.h>' b64.c
  '';

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc-full libxslt gengetopt ];
  buildInputs = [ libfido2 libressl pam ];

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
