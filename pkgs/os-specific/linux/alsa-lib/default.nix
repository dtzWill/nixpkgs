{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-lib";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://alsa/lib/${pname}-${version}.tar.bz2";
    sha256 = "1ky7mpxr1s6gj1lyhlfrnp23i09rvjy47c4c9h1nijwg3qdzy3cz";
  };

  patches = [
    ./alsa-plugin-conf-multilib.patch
  ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    homepage = http://www.alsa-project.org/;
    description = "ALSA, the Advanced Linux Sound Architecture libraries";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
