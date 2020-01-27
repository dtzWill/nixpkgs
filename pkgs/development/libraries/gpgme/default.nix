{ stdenv, fetchurl, fetchpatch, libgpgerror, gnupg, pkgconfig, glib, pth, libassuan
, file, which, ncurses
, texinfo
, buildPackages
, qtbase ? null
, pythonSupport ? false, swig2 ? null, python ? null
}:

let
  inherit (stdenv) lib;
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation rec {
  name = "gpgme-${version}";
  version = "1.13.1";

  src = fetchurl {
    url = "mirror://gnupg/gpgme/${name}.tar.bz2";
    sha256 = "0imyjfryvvjdbai454p70zcr95m94j9xnzywrlilqdw2fqi0pqy4";
  };

  patches = [ (fetchpatch {
    # Commit message explains it nicely:
    # > Without this change, the signature verification would fail.  This
    # > problem was introduced in bded8ebc59c7fdad2617f4c9232a58047656834c in
    # > an attempt to avoid an error when *not* verifying.  Clearly more test
    # > suite coverage is needed to avoid introducing this sort of problem in
    # > the future.
    # This failure is also caught by recent notmuch testsuite.
    url = "https://sources.debian.org/data/main/g/gpgme1.0/1.13.0-2/debian/patches/0002-gpg-Avoid-error-diagnostics-with-override-session-ke.patch";
    sha256 = "1684fpr8ggg0f40231jyaviw6y2zyq3g8ngckw26w8892r1siqcn";
  }) ];

  outputs = [ "out" "dev" "info" ];
  outputBin = "dev"; # gpgme-config; not so sure about gpgme-tool

  propagatedBuildInputs =
    [ libgpgerror glib libassuan pth ]
    ++ lib.optional (qtbase != null) qtbase;

  nativeBuildInputs = [ file pkgconfig gnupg texinfo ]
  ++ lib.optionals pythonSupport [ python swig2 which ncurses ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch =''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  configureFlags = [
    "--enable-fixed-path=${gnupg}/bin"
    "--with-libgpg-error-prefix=${libgpgerror.dev}"
    "--with-libassuan-prefix=${libassuan.dev}"
  ] ++ lib.optional pythonSupport "--enable-languages=python"
  # Tests will try to communicate with gpg-agent instance via a UNIX socket
  # which has a path length limit. Nix on darwin is using a build directory
  # that already has quite a long path and the resulting socket path doesn't
  # fit in the limit. https://github.com/NixOS/nix/pull/1085
    ++ lib.optionals stdenv.isDarwin [ "--disable-gpg-test" ];

  NIX_CFLAGS_COMPILE =
    # qgpgme uses Q_ASSERT which retains build inputs at runtime unless
    # debugging is disabled
    lib.optional (qtbase != null) "-DQT_NO_DEBUG"
    # https://www.gnupg.org/documentation/manuals/gpgme/Largefile-Support-_0028LFS_0029.html
    ++ lib.optional (system == "i686-linux") "-D_FILE_OFFSET_BITS=64";

  checkInputs = [ which ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://gnupg.org/software/gpgme/index.html;
    description = "Library for making GnuPG easier to use";
    longDescription = ''
      GnuPG Made Easy (GPGME) is a library designed to make access to GnuPG
      easier for applications. It provides a High-Level Crypto API for
      encryption, decryption, signing, signature verification and key
      management.
    '';
    license = with licenses; [ lgpl21Plus gpl3Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
