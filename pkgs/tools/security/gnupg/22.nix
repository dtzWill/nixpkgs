{ fetchurl, stdenv, fetchgit, pkgconfig, libgcrypt, libassuan, libksba
, libiconv, npth, gettext, texinfo, pcsclite, sqlite, autoreconfHook, gawk

# Each of the dependencies below are optional.
# Gnupg can be built without them at the cost of reduced functionality.
, pinentry ? null, guiSupport ? true
, adns ? null, gnutls ? null, libusb ? null, openldap ? null
, readline ? null, zlib ? null, bzip2 ? null
}:

with stdenv.lib;

assert guiSupport -> pinentry != null;

stdenv.mkDerivation rec {
  name = "gnupg-${version}";

  version = "2.2.12";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "1jw282iy27j1qygym52aa44zxy7ly4bdadhd628hwr4q9j5hy0yv";
  };
  #src = fetchgit {
  #  url = https://dev.gnupg.org/source/gnupg.git;
  #  rev = "d93797c8a7892fe26672c551017468e9f8099ef6";
  #  sha256 = "1qj2xd0ihpp9nbfd2kkkl0mp211sr8cidw5b6p6yfmmw4qhcxzwl";
  #};

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libgcrypt libassuan libksba libiconv npth gettext texinfo
    readline libusb gnutls adns openldap zlib bzip2 sqlite
  ];

  patches = [
    ./fix-libusb-include-path.patch
  ];
  postPatch = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i 's,"libpcsclite\.so[^"]*","${stdenv.lib.getLib pcsclite}/lib/libpcsclite.so",g' scd/scdaemon.c
  ''; #" fix Emacs syntax highlighting :-(

  pinentryBinaryPath = pinentry.binaryPath or "bin/pinentry";
  configureFlags = optional guiSupport "--with-pinentry-pgm=${pinentry}/${pinentryBinaryPath}";

  postInstall = ''
    mkdir -p $out/lib/systemd/user
    for f in doc/examples/systemd-user/*.{service,socket} ; do
      substitute $f $out/lib/systemd/user/$(basename $f) \
        --replace /usr/bin $out/bin
    done

    # add gpg2 symlink to make sure git does not break when signing commits
    ln -s $out/bin/gpg $out/bin/gpg2
  '';

  meta = with stdenv.lib; {
    homepage = https://gnupg.org;
    description = "Modern (2.1) release of the GNU Privacy Guard, a GPL OpenPGP implementation";
    license = licenses.gpl3Plus;
    longDescription = ''
      The GNU Privacy Guard is the GNU project's complete and free
      implementation of the OpenPGP standard as defined by RFC4880.  GnuPG
      "modern" (2.1) is the latest development with a lot of new features.
      GnuPG allows to encrypt and sign your data and communication, features a
      versatile key management system as well as access modules for all kind of
      public key directories.  GnuPG, also known as GPG, is a command line tool
      with features for easy integration with other applications.  A wealth of
      frontend applications and libraries are available.  Version 2 of GnuPG
      also provides support for S/MIME.
    '';
    maintainers = with maintainers; [ peti fpletz vrthra ];
    platforms = platforms.all;
  };
}
