{ stdenv, fetchpatch, fetchurl, python3Packages, librsync, ncftp, gnupg
, gnutar
, par2cmdline
, utillinux
, rsync, backblaze-b2, makeWrapper }:

python3Packages.buildPythonApplication rec {
  pname = "duplicity";
  version = "0.8.07";

  src = fetchurl {
    url = "https://launchpad.net/duplicity/${stdenv.lib.versions.majorMinor version}-series/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "109pq7qb0s4l3hvs08lry1l8nldfdp6xj4wdkjgmm91zfq4a2qg9";
  };
  patches = stdenv.lib.optional stdenv.isLinux ./linux-disable-timezone-test.patch;

  buildInputs = [ librsync makeWrapper python3Packages.wrapPython ];
  propagatedBuildInputs = [ backblaze-b2 ] ++ (with python3Packages; [
    boto cffi cryptography ecdsa idna pygobject3 fasteners
    ipaddress lockfile paramiko pyasn1 pycrypto six future
  ]);
  checkInputs = [
    gnupg  # Add 'gpg' to PATH.
    gnutar  # Add 'tar' to PATH.
    librsync  # Add 'rdiff' to PATH.
    par2cmdline  # Add 'par2' to PATH.
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    utillinux  # Add 'setsid' to PATH.
  ] ++ (with python3Packages; [ lockfile mock pexpect pytest pytestrunner fasteners]);

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

    ln -sf $out/bin/{duplicity,rdiffdir} ./bin/

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
