{ stdenv, fetchgit, autoreconfHook, pkgconfig, ell, coreutils, readline, docutils, openssl, python3Packages }:

# TODO: install the 'ios_convert.py' script added in d8dac9a330be3514a0ee8437ca020dee968a05ca
# (and any req'd dependencies/wrapping, not sure)
stdenv.mkDerivation rec {
  pname = "iwd";

  #version = "1.2";
  version = "unstable-2019-11-30";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "d2556a48b7d65eb670fb0ce20e3f929bf9839a20";
    #rev = version;
    sha256 = "13jp8pf6qprsaclnpmqmz4zgapbj0iw7gvii0n7p2nawynkzcpc0";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    docutils # rst2man
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
    "--with-dbus-datadir=${placeholder "out"}/etc/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/" # maybe
    "--localstatedir=/var/"
    "--enable-wired"
    "--enable-external-ell"
    "--enable-ofono"

    # XXX: ?!
    # iwd wants to disable persistent naming, via installed .link?
    "--with-systemd-networkdir=${placeholder "out"}/lib/systemd/system/"

    "--enable-debug"
    "--enable-asan"
    "--enable-ubsan"
  ];

  #separateDebugInfo = true;
  dontStrip = true; # leave

  postUnpack = ''
    patchShebangs .
  '';

  patches = [
    # Fix write past end of buffer in certain circumstances
    # ... circumstances I encounter often, thanks neighbors ;)
    ./completion-crash-fix-wip.patch
  ];

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
