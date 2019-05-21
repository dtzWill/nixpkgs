{ stdenv, fetchurl, pkgconfig
, libpcap, ncurses, expat, pcre, libmicrohttpd, libnl
, libcap , protobuf, protobufc, sqlite, zlib
, libbfd /* or libdw (elfutils) */
, libutil, libunwind, libusb, lm_sensors
, withNM ? true, networkmanager ? null
}:

stdenv.mkDerivation rec {
  name = "kismet-${version}";
  version = "2019-04-R1";

  src = fetchurl {
    url = "https://www.kismetwireless.net/code/${name}.tar.xz";
    sha256 = "143p19cya38kwsfsnh01f97gaiy5hviv641sb06adhmbfcs5wmv0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libpcap ncurses expat pcre libmicrohttpd libnl
    libcap protobuf protobufc sqlite zlib
    libbfd libutil libunwind libusb lm_sensors
  ] ++ stdenv.lib.optional withNM networkmanager;

  configureFlags = [ "--disable-python-tools" /* TODO */ ];
  #postConfigure = ''
  #  sed -e 's/-o $(INSTUSR)//' \
  #      -e 's/-g $(INSTGRP)//' \
  #      -e 's/-g $(MANGRP)//' \
  #      -e 's/-g $(SUIDGROUP)//' \
  #      -i Makefile
  #'';

  meta = with stdenv.lib; {
    description = "Wireless network sniffer";
    homepage = https://www.kismetwireless.net/;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
