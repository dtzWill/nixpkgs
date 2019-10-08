{ stdenv, fetchgit, autoreconfHook, pkgconfig, ell, coreutils, readline, docutils, openssl, python3Packages }:

# TODO: install the 'ios_convert.py' script added in d8dac9a330be3514a0ee8437ca020dee968a05ca
# (and any req'd dependencies/wrapping, not sure)
stdenv.mkDerivation rec {
  pname = "iwd";

  #version = "0.21";
  version = "2019-10-07";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    #rev = version;
    rev = "d2e4b7d288d7699365fd12fa034ce4f56409f309";
    sha256 = "1898j1z5fbw46km9wd5h741kymv8b1m99xknbnjcymba6n0zq5p5";
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

    "--enable-debug"
    "--enable-asan"
    "--enable-ubsan"
  ];

  separateDebugInfo = true;

  postUnpack = ''
    patchShebangs .
  '';

  postPatch = ''
    # Disable test-eapol, requires loading 'pkcs8_key_parser' kernel module (on builder)
    sed -i Makefile.am -e 's,\<unit/test-eapol\>,,'
    # Tweak variable names to quiet warnings about nothing having the canonical name we just removed
    sed -i Makefile.am -e 's,^unit_test_eapol_[A-Z]\+\>,&_disabled,'
  '';

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
