{ stdenv
, fetchgit
, fetchpatch
, autoreconfHook
, pkgconfig
, ell
, coreutils
, docutils
, readline
, openssl
, python3Packages
, enableAsan ? false
, enableUbsan ? false
}:

stdenv.mkDerivation rec {
  pname = "iwd";

  #version = "1.5";
  version = "unstable-2020-03-24";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    #rev = version;
    rev = "72bf3aa1f5de61ef2fab9569015ea094e6fa4741";
    sha256 = "12bydmxv7iaqsjs0kv67g6pqkjab0zn54xwrlc383a1gq21sqdl3";
  };

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    readline
    python3Packages.python
  ];

  checkInputs = [ openssl ];

  pythonPath = with python3Packages; [
    dbus-python
    pygobject3
  ];

  configureFlags = [
    "--enable-external-ell"
    "--enable-wired"
    "--localstatedir=/var/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-dbus-datadir=${placeholder "out"}/share/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/" # maybe
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
    "--with-systemd-networkdir=${placeholder "out"}/lib/systemd/network/"

    "--enable-ofono"
  ]
    ++ stdenv.lib.optional enableAsan "--enable-asan"
    ++ stdenv.lib.optional enableUbsan "--enable-ubsan";

  #separateDebugInfo = true;
  #dontStrip = true; # leave, separateDebugInfo works best for upstream-built packages

  postUnpack = ''
    patchShebangs .
  '';

  # Experimentally drop this patch, let's see if still needed
  ## patches = [
  ##   # Fix write past end of buffer in certain circumstances
  ##   # ... circumstances I encounter often, thanks neighbors ;)
  ##   ./completion-crash-fix-wip.patch
  ## ];

  doCheck = true;

  postInstall = ''
    cp -a test/* $out/bin/
    mkdir -p $out/share
    cp -a doc $out/share/
    cp -a README AUTHORS TODO $out/share/doc/
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/system-services/net.connman.ead.service \
                      --replace /bin/false ${coreutils}/bin/false
    substituteInPlace $out/share/dbus-1/system-services/net.connman.iwd.service \
                      --replace /bin/false ${coreutils}/bin/false
  '';

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
