# set VAMP_PATH ?
# plugins availible on sourceforge and http://www.vamp-plugins.org/download.html (various licenses)

{ stdenv, fetchFromGitHub, pkgconfig, libsndfile }:

rec {

  vampSDK = stdenv.mkDerivation rec {
    pname = "vamp-sdk";
    version = "2.8";

    src = fetchFromGitHub {
      owner = "c4dm";
      repo = "vamp-plugin-sdk";
      rev = "vamp-plugin-sdk-v${version}";
      sha256 = "0h3g1q4x5sri4cf44xcndj2vvrgc7rd8wzynnk579zd073iwxq91";
    };

  nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libsndfile ];

    meta = with stdenv.lib; {
      description = "Audio processing plugin system for plugins that extract descriptive information from audio data";
      homepage = https://sourceforge.net/projects/vamp;
      license = licenses.bsd3;
      maintainers = [ maintainers.goibhniu maintainers.marcweber ];
      platforms = platforms.linux;
    };
  };

}
