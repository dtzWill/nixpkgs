{ stdenv, fetchFromGitHub, autoreconfHook
, pkgconfig, dbus, dbus-glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "thermald-${version}";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "1g1l7k8yxj8bl1ysdx8v6anv1s7xk9j072y44gwki70dy48n7j92";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ dbus dbus-glib libxml2 ];

  configureFlags = [
    "--sysconfdir=$(out)/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=$(out)/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = https://01.org/linux-thermal-daemon;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
