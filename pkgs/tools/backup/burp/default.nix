{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  name = "burp-${version}";
  version = "2.3.22";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "186ai8isqqrx4kpq2nj9q3ikfd3q628007yiaffv142nls9qs1js";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ librsync ncurses openssl zlib uthash ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with stdenv.lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = https://burp.grke.org;
    license     = licenses.agpl3;
    maintainers = with maintainers; [ tokudan ];
    platforms   = platforms.all;
  };
}
