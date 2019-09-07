{ stdenv, fetchurl, fetchFromGitHub, autoreconfHook, pkgconfig, glib, python3, libgudev, libmbim }:

stdenv.mkDerivation rec {
  pname = "libqmi";
  #version = "1.22.4";
  version = "1.22.4-git-2019-09-03";

  src = fetchFromGitHub {
    owner = "freedesktop";
    repo = pname;
    rev = "ef6f0038ddbbe9e5d8378625579013291b55e554";
    sha256 = "0dzlawzfw8jb0jd15vrvls32d01a5bipjpn8f0rb0h5lars5gw6q";
  };
  #src = fetchurl {
  #  url = "https://www.freedesktop.org/software/libqmi/${pname}-${version}.tar.xz";
  #  sha256 = "1wgrrb9vb3myl8xgck8ik86876ycbg8crylybs3ssi21vrxqwnsc";
  #};

  outputs = [ "out" "dev" "devdoc" ];

  configureFlags = [
    "--with-udev-base-dir=${placeholder "out"}/lib/udev"
  ];

  nativeBuildInputs = [
    autoreconfHook # needed when building from git
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
    libgudev
    libmbim
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://www.freedesktop.org/wiki/Software/libqmi;
    description = "Modem protocol helper library";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
