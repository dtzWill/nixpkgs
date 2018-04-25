{ stdenv, lib, fetchFromGitHub, makeWrapper, autoreconfHook,
  fuse, libmspack, openssl, pam, xercesc, icu, libdnet, procps,
  libX11, libXext, libXinerama, libXi, libXrender, libXrandr, libXtst,
  pkgconfig, glib, gtk3, gtkmm3, iproute, dbus, systemd, which, udev, libdrm,
  withX ? true, cunit, doCheck ? true }:

stdenv.mkDerivation rec {
  name = "open-vm-tools-${version}";
  version = "10.2.5";

  src = fetchFromGitHub {
    owner  = "vmware";
    repo   = "open-vm-tools";
    rev    = "stable-${version}";
    sha256 = "16ax8ajrci6vlgra3dwsqcr0c23c6k9iz9i82459hnfwqfqakvmn";
  };

  sourceRoot = "${src.name}/open-vm-tools";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig ];
  buildInputs = [ fuse glib icu libdnet libmspack openssl pam procps xercesc udev libdrm ]
      ++ lib.optionals withX [ gtk3 gtkmm3 libX11 libXext libXinerama libXi libXrender libXrandr libXtst ]
      ++ lib.optional doCheck cunit;

  patches = [ ./recognize_nixos.patch ];

  # TODO: there are many hardcoded paths throughout the source
  postPatch = ''
     sed -i 's,^confdir = ,confdir = ''${prefix},' scripts/Makefile.am
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' services/vmtoolsd/Makefile.am
     sed -i 's,$(PAM_PREFIX),''${prefix}/$(PAM_PREFIX),' services/vmtoolsd/Makefile.am
     sed -i 's,$(UDEVRULESDIR),''${prefix}/$(UDEVRULESDIR),' udev/Makefile.am

     # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
     sed 1i'#include <sys/sysmacros.h>' -i lib/wiper/wiperPosix.c

     # Make reboot work, shutdown is not in /sbin on NixOS
     sed -i 's,/sbin/shutdown,shutdown,' lib/system/systemLinux.c
  '';

  configureFlags = [ "--without-kernel-modules" "--without-xmlsecurity" ]
    ++ lib.optional (!withX) "--without-x";

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram "$out/etc/vmware-tools/scripts/vmware/network" \
      --prefix PATH ':' "${lib.makeBinPath [ iproute dbus systemd which ]}"
  '';

  inherit doCheck;

  meta = with stdenv.lib; {
    homepage = https://github.com/vmware/open-vm-tools;
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for
      better management of, and seamless user interactions with, guests.
    '';
    license = licenses.gpl2;
    platforms =  [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ joamaki ];
  };
}
