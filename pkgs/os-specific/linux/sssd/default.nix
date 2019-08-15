{ stdenv, fetchurl, glibc, augeas, dnsutils, c-ares, curl,
  cyrus_sasl, ding-libs, libnl, libunistring, nss, samba, nfs-utils, doxygen,
  python, python3, pam, popt, talloc, tdb, tevent, pkgconfig, ldb, openldap,
  pcre, kerberos, cifs-utils, glib, keyutils, dbus, fakeroot, libxslt, libxml2,
  libuuid, ldap, systemd, nspr, check, cmocka, uid_wrapper,
  nss_wrapper, ncurses, Po4a, http-parser, jansson,
  docbook_xsl, docbook_xml_dtd_44,
  withSudo ? false }:

let
  docbookFiles = "${docbook_xsl}/share/xml/docbook-xsl/catalog.xml:${docbook_xml_dtd_44}/xml/dtd/docbook/catalog.xml";
in
stdenv.mkDerivation rec {
  pname = "sssd";
  version = "2.2.0";

  src = fetchurl {
    url = "https://fedorahosted.org/released/sssd/${pname}-${version}.tar.gz";
    sha256 = "0n45v2vlb3l8fx63fgb23h1yysw9hbmdngc5h4a4l5ywqxrqsqdf";
  };

  # Something is looking for <libxml/foo.h> instead of <libxml2/libxml/foo.h>
  NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";

  preConfigure = ''
    export SGML_CATALOG_FILES="${docbookFiles}"
    export PYTHONPATH=${ldap}/lib/python2.7/site-packages
    export PATH=$PATH:${openldap}/libexec

    configureFlagsArray+=(
      --with-xml-catalog-path=''${SGML_CATALOG_FILES%%:*}
    )
  '' + stdenv.lib.optionalString withSudo ''
    configureFlagsArray+=("--with-sudo")
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-pammoddir=${placeholder "out"}/lib/security"
    "--with-os=fedora"
    "--with-pid-path=/run"
    "--with-python2-bindings"
    "--with-python3-bindings"
    "--with-syslog=journald"
    "--without-selinux"
    "--without-semanage"
    "--with-ldb-lib-dir=${placeholder "out"}/modules/ldb"
    "--with-nscd=${glibc.bin}/sbin/nscd"
  ];

  enableParallelBuilding = true;
  buildInputs = [ augeas dnsutils c-ares curl cyrus_sasl ding-libs libnl libunistring nss
                  samba nfs-utils doxygen python python3 popt
                  talloc tdb tevent pkgconfig ldb pam openldap pcre kerberos
                  cifs-utils glib keyutils dbus fakeroot libxslt libxml2
                  libuuid ldap systemd nspr check cmocka uid_wrapper
                  nss_wrapper ncurses Po4a http-parser jansson ];

  makeFlags = [
    "SGML_CATALOG_FILES=${docbookFiles}"
  ];

  installFlags = [
     "sysconfdir=${placeholder "out"}/etc"
     "localstatedir=${placeholder "out"}/var"
     "pidpath=${placeholder "out"}/run"
     "sss_statedir=${placeholder "out"}/var/lib/sss"
     "logpath=${placeholder "out"}/var/log/sssd"
     "pubconfpath=${placeholder "out"}/var/lib/sss/pubconf"
     "dbpath=${placeholder "out"}/var/lib/sss/db"
     "mcpath=${placeholder "out"}/var/lib/sss/mc"
     "pipepath=${placeholder "out"}/var/lib/sss/pipes"
     "gpocachepath=${placeholder "out"}/var/lib/sss/gpo_cache"
     "secdbpath=${placeholder "out"}/var/lib/sss/secrets"
     "initdir=${placeholder "out"}/rc.d/init"
  ];

  postInstall = ''
    rm -rf "$out"/run
    rm -rf "$out"/rc.d
    rm -f "$out"/modules/ldb/memberof.la
    find "$out" -depth -type d -exec rmdir --ignore-fail-on-non-empty {} \;
  '';

  meta = with stdenv.lib; {
    description = "System Security Services Daemon";
    homepage = https://fedorahosted.org/sssd/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.e-user ];
  };
}
