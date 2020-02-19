{ stdenv, fetchurl, fetchpatch, pkgconfig, dbus, nettle
, libidn2, libnetfilter_conntrack }:

with stdenv.lib;
let
  copts = concatStringsSep " " ([
    "-DHAVE_IDN2"
    "-DHAVE_DNSSEC"
  ] ++ optionals stdenv.isLinux [
    "-DHAVE_DBUS"
    "-DHAVE_CONNTRACK"
  ]);
in
stdenv.mkDerivation rec {
  pname = "dnsmasq";
  version = "2.80";

  src = fetchurl {
    url = "http://www.thekelleys.org.uk/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1fv3g8vikj3sn37x1j6qsywn09w1jipvlv34j3q5qrljbrwa5ayd";
  };

  patches = [
    (fetchpatch {
      name = "fix-for-nettle-3.5.patch";
      url = "http://thekelleys.org.uk/gitweb/?p=dnsmasq.git;a=commitdiff_plain;h=ab73a746a0d6fcac2e682c5548eeb87fb9c9c82e;hp=69bc94779c2f035a9fffdb5327a54c3aeca73ed5";
      sha256 = "1hnixij3jp1p6zc3bx2dr92yyf9jp1ahhl9hiiq7bkbhbrw6mbic";
    })
  ];
  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isLinux ''
    sed '1i#include <linux/sockios.h>' -i src/dhcp.c
  '';

  preBuild = ''
    makeFlagsArray=("COPTS=${copts}")
  '';

  makeFlags = [
    "DESTDIR="
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/man"
    "LOCALEDIR=${placeholder "out"}/share/locale"
  ];

  hardeningEnable = [ "pie" ];

  postBuild = optionalString stdenv.isLinux ''
    make -C contrib/lease-tools
  '';

  # XXX: Does the systemd service definition really belong here when our NixOS
  # module can create it in Nix-land?
  postInstall = ''
    install -Dm644 trust-anchors.conf $out/share/dnsmasq/trust-anchors.conf
  '' + optionalString stdenv.isDarwin ''
    install -Dm644 contrib/MacOSX-launchd/uk.org.thekelleys.dnsmasq.plist \
      $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist
    substituteInPlace $out/Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist \
      --replace "/usr/local/sbin" "$out/bin"
  '' + optionalString stdenv.isLinux ''
    install -Dm644 dbus/dnsmasq.conf $out/etc/dbus-1/system.d/dnsmasq.conf
    install -Dm755 contrib/lease-tools/dhcp_lease_time $out/bin/dhcp_lease_time
    install -Dm755 contrib/lease-tools/dhcp_release $out/bin/dhcp_release
    install -Dm755 contrib/lease-tools/dhcp_release6 $out/bin/dhcp_release6

    mkdir -p $out/share/dbus-1/system-services
    cat <<END > $out/share/dbus-1/system-services/uk.org.thekelleys.dnsmasq.service
    [D-BUS Service]
    Name=uk.org.thekelleys.dnsmasq
    Exec=$out/bin/dnsmasq -k -1
    User=root
    SystemdService=dnsmasq.service
    END
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ nettle libidn2 ]
    ++ optionals stdenv.isLinux [ dbus libnetfilter_conntrack ];

  meta = {
    description = "An integrated DNS, DHCP and TFTP server for small networks";
    homepage = http://www.thekelleys.org.uk/dnsmasq/doc.html;
    license = licenses.gpl2;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ eelco fpletz globin ];
  };
}
