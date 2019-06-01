{ stdenv, fetchurl, pkgconfig, qmake, qtscript, qtsvg, dbus }:

stdenv.mkDerivation rec {
  pname = "vym";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${version}/${pname}-${version}.tar.bz2";
    sha256 = "0lyf0m4y5kn5s47z4sg10215f3jsn3k1bl389jfbh2f5v4srav4g";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtscript qtsvg ];

  meta = with stdenv.lib; {
    description = "A mind-mapping software";
    longDescription = ''
      VYM (View Your Mind) is a tool to generate and manipulate maps which show your thoughts.
      Such maps can help you to improve your creativity and effectivity. You can use them
      for time management, to organize tasks, to get an overview over complex contexts,
      to sort your ideas etc.

      Maps can be drawn by hand on paper or a flip chart and help to structure your thoughs.
      While a tree like structure like shown on this page can be drawn by hand or any drawing software
      vym offers much more features to work with such maps.
    '';
    homepage = http://www.insilmaril.de/vym/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
