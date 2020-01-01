{ stdenv, fetchFromGitHub, perl, gettext, pkgconfig, libidn2, libiconv }:

stdenv.mkDerivation rec {
  version = "5.5.4";
  pname = "whois";

  src = fetchFromGitHub {
    owner = "rfc1036";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ky4c7xyvshrgnyk8vs3gc9kwhlbxkh3qf5hcdy7ibvnz4zznsbs";
  };

  nativeBuildInputs = [ perl gettext pkgconfig ];
  buildInputs = [ libidn2 libiconv ];

  preConfigure = ''
    for i in Makefile po/Makefile; do
      substituteInPlace $i --replace "prefix = /usr" "prefix = $out"
    done
  '';

  makeFlags = [ "HAVE_ICONV=1" ];
  buildFlags = [ "whois" ];

  installTargets = [ "install-whois" ];

  meta = with stdenv.lib; {
    description = "Intelligent WHOIS client from Debian";
    longDescription = ''
      This package provides a commandline client for the WHOIS (RFC 3912)
      protocol, which queries online servers for information such as contact
      details for domains and IP address assignments. It can intelligently
      select the appropriate WHOIS server for most queries.
    '';

    homepage = https://packages.qa.debian.org/w/whois.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
