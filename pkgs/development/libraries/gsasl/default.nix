{ fetchurl, stdenv, libidn, kerberos, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "gsasl";
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1lnqfbaajkj1r2fx1db1qgcxy69pfgbyq7xd2kpvyxhra4m1dnjd";
  };

  buildInputs = [ libidn kerberos libgcrypt ];

  configureFlags = [ "--with-gssapi-impl=mit" ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "GNU SASL, Simple Authentication and Security Layer library";

    longDescription =
      '' GNU SASL is a library that implements the IETF Simple 
         Authentication and Security Layer (SASL) framework and 
         some SASL mechanisms. SASL is used in network servers 
         (e.g. IMAP, SMTP, etc.) to authenticate peers. 
       '';

    homepage = https://www.gnu.org/software/gsasl/;
    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = with stdenv.lib.maintainers; [ shlevy ];
    platforms = stdenv.lib.platforms.all;
  };
}
