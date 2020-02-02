{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper, autoconf-archive
, pkgconfig, dbus, dbus-glib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "unstable-2020-01-29";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "7538855b2b1a91acde80e1b5c5b1ed67781d399c";
    sha256 = "1r2ll0hrgfyj0ndkvcsdicprx0i8q2a38ybgsdnp7mgqii16fbzr";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook autoconf-archive makeWrapper ];
  buildInputs = [ dbus dbus-glib libxml2 ];

  patches = [
    ./0002-Don-t-keep-on-reading-a-sensor-if-the-temperature-is.patch
    ./0003-thermald-fix-uninitialised-member.patch
    ./0004-Remove-processing-when-trip-was-not-activates.patch
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    ];

  postInstall = ''
    mkdir -p $out/bin
    cp ./tools/thermald_set_pref.sh $out/bin/

    patchShebangs $out/bin/thermald_set_pref.sh
    wrapProgram $out/bin/thermald_set_pref.sh --prefix PATH ':' ${stdenv.lib.makeBinPath [ dbus ]}
  '';

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = https://01.org/linux-thermal-daemon;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
