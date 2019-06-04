{ stdenv, fetchurl, fetchFromGitHub, libv4l, gd }:

stdenv.mkDerivation rec {
  pname = "fswebcam";
  version = "2019-03-07";

  #src = fetchurl {
  #  url = "https://www.sanslogic.co.uk/fswebcam/files/${name}.tar.gz";
  #  sha256 = "3ee389f72a7737700d22e0c954720b1e3bbadc8a0daad6426c25489ba9dc3199";
  #};
  src = fetchFromGitHub {
    owner = "fsphil";
    repo = pname;
    rev = "9a995d6a5369ddd158e352766e015dae20982318";
    sha256 = "17zwx2bs0ffgiq1di1c8gvi07m1b37d8bd1nhl1bhypyqqhpf4rd";
  };

  buildInputs =
    [ libv4l gd ];

  meta = {
    description = "Neat and simple webcam app";
    homepage = http://www.sanslogic.co.uk/fswebcam;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
