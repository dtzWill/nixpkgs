{ stdenv, fetchhg, pidgin, glib, json-glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  pname = "purple-hangouts-hg";
  version = "2020-04-23";

  src = fetchhg {
    url = "https://keep.imfreedom.org/eion/purple-hangouts";
    rev = "ec3324659888";
    sha256 = "1p1hd26p77163zyq5ccmdfa8jjbjm658rl541f4j4zkz5vdxxj2h";
  };

  buildInputs = [ pidgin glib json-glib protobuf protobufc ];

  PKG_CONFIG_PURPLE_PLUGINDIR = "${placeholder "out"}/lib/purple-2";
  PKG_CONFIG_PURPLE_DATADIR = "${placeholder "out"}/share";

  meta = with stdenv.lib; {
    homepage = https://bitbucket.org/EionRobb/purple-hangouts;
    description = "Native Hangouts support for pidgin";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ralith ];
  };
}
