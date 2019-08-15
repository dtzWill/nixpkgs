{ stdenv, fetchhg, pidgin, glib, json-glib, protobuf, protobufc }:

stdenv.mkDerivation rec {
  pname = "purple-hangouts-hg";
  version = "2019-06-06";

  src = fetchhg {
    url = "https://bitbucket.org/EionRobb/purple-hangouts/";
    rev = "3f7d89b";
    sha256 = "10prcydwz5p0p16m9arlyn5xg9dipyw5l8q9kahw8v0sv2aklifp";
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
