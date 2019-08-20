{ stdenv, fetchFromGitHub, pkgconfig
, dbus, pcre, epoxy, libXdmcp, at-spi2-core, libxklavier, libxkbcommon, libpthreadstubs
, gtk3, vala, cmake, libgee, libX11, lightdm, gdk-pixbuf, clutter-gtk }:

stdenv.mkDerivation rec {
  pname = "lightdm-enso-os-greeter";
  version = "2019-01-15";

  src = fetchFromGitHub {
    owner = "nick92";
    repo = "Enso-OS";
    rev = "14bf28e59ede7c57467e21a39c82792dbf531f9c";
    sha256 = "1y4sbqhv2zhxfxbri1hal26ba7afj4i7ci0w18p5dk7k8xqq77kc";
  };

  buildInputs = [
    dbus
    gtk3
    pcre
    vala
    epoxy
    libgee
    libX11
    lightdm
    libXdmcp
    gdk-pixbuf
    clutter-gtk
    libxklavier
    at-spi2-core
    libxkbcommon
    libpthreadstubs
  ];

  nativeBuildInputs = [
    pkgconfig
    cmake
  ];

  sourceRoot = "source/greeter";

  postPatch = ''
    sed -i "s@\''${CMAKE_INSTALL_PREFIX}/@@" CMakeLists.txt
    substituteInPlace CMakeLists.txt --replace /usr /
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = ''
      A fork of pantheon greeter that positions elements in a central and
      vertigal manner and adds a blur effect to the background
    '';
    homepage = https://github.com/nick92/Enso-OS;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
