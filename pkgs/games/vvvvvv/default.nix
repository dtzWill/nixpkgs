{ stdenv, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  dataZip = if fullGame then requireFile {
    name = "data.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
    message = ''
      In order to install VVVVVV, you must first download the game's
      data file (data.zip) as it is not released freely.
      Once you have downloaded the file, place it in your current
      directory, use the following command and re-run the installation:
      nix-prefetch-url file://\$PWD/data.zip
    '';
  } else fetchurl {
    url = https://thelettervsixtim.es/makeandplay/data.zip;
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
  };
in stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "unstable-2020-01-22";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "f9525020bbcb4c2f5c44218cadcd475bcc1d2037";
    sha256 = "1z5lp456s4lvbihdr5mfqrhxj9b84rnacj5cd6zzsyf1pf6wifp6";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ SDL2 SDL2_mixer ];

  preConfigure = ''
    cd desktop_version
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -t $out/bin VVVVVV
    cp ${dataZip} $out/bin/data.zip
  '';

  meta = with stdenv.lib; {
    description = "A platform game based on flipping gravity";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping? 
    '';
    homepage = https://thelettervsixtim.es;
    license = licenses.unfree;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.all;
  };
}
