{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "joypixels";
  version = "5.0.3";

  src = fetchurl {
    url = "https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf";
    sha256 = "14dh6xzxr5qv635v2dvj6a7lndxgjd88i3c1s1kn2hr8z0bxqav2";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 $src $out/share/fonts/truetype/joypixels.ttf
  '';

  meta = with stdenv.lib; {
    description = "Emoji as a Service (formerly EmojiOne)";
    homepage = https://www.joypixels.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ jtojnar ];
  };
}
