{ stdenv, fetchFromGitHub, autoreconfHook, makeWrapper
, pkgconfig, dbus, dbus-glib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "thermald";
  #version = "1.9.1";
  version = "2.0.0pre";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    #rev = "v${version}";
    rev = "97c6577a3493f7d417847236c05f8e65b0fadb84";
    sha256 = "0xqw1q1h480ikbpj4dix62q31z4b189znp4ldlmvbk434r93fmnb";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook makeWrapper ];
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
