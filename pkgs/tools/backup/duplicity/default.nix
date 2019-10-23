{ stdenv, fetchpatch, fetchurl, python2Packages, librsync, ncftp, gnupg
, gnutar
, par2cmdline
, utillinux
, rsync, backblaze-b2, makeWrapper }:

python2Packages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.05";

  src = fetchurl {
    url = "https://launchpad.net/duplicity/${stdenv.lib.versions.majorMinor version}-series/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "078ilcnlpmwdmivhvim1dbh6vy1as69q9jnpy82zy0r0977p4ih6";
  };
  patches = [
    ./gnutar-in-test.patch
    ./use-installed-scripts-in-test.patch
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    ./linux-disable-timezone-test.patch
  ];

  buildInputs = [ librsync makeWrapper python2Packages.wrapPython ];
  propagatedBuildInputs = [ backblaze-b2 ] ++ (with python2Packages; [
    boto cffi cryptography ecdsa enum idna pygobject3 fasteners
    ipaddress lockfile paramiko pyasn1 pycrypto six
  ]);
  checkInputs = [
    gnupg  # Add 'gpg' to PATH.
    gnutar  # Add 'tar' to PATH.
    librsync  # Add 'rdiff' to PATH.
    par2cmdline  # Add 'par2' to PATH.
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    utillinux  # Add 'setsid' to PATH.
  ] ++ (with python2Packages; [ lockfile mock pexpect ]);

  postInstall = ''
    wrapProgram $out/bin/duplicity \
      --prefix PATH : "${stdenv.lib.makeBinPath [ gnupg ncftp rsync ]}"

    wrapPythonPrograms
  '';

  preCheck = ''
    wrapPythonProgramsIn "$PWD/testing/overrides/bin" "$pythonPath"

    # Add 'duplicity' to PATH for tests.
    # Normally, 'setup.py test' adds 'build/scripts-2.7/' to PATH before running
    # tests. However, 'build/scripts-2.7/duplicity' is not wrapped, so its
    # shebang is incorrect and it fails to run inside Nix' sandbox.
    # In combination with use-installed-scripts-in-test.patch, make 'setup.py
    # test' use the installed 'duplicity' instead.
    PATH="$out/bin:$PATH"

    # Don't run developer-only checks (pep8, etc.).
    export RUN_CODE_TESTS=0
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    # Work around the following error when running tests:
    # > Max open files of 256 is too low, should be >= 1024.
    # > Use 'ulimit -n 1024' or higher to correct.
    ulimit -n 1024
  '';

  # TODO: Fix test failures on macOS 10.13:
  #
  # > OSError: out of pty devices
  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "Encrypted bandwidth-efficient backup using the rsync algorithm";
    homepage = https://www.nongnu.org/duplicity;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms = platforms.unix;
  };
}
