{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.15.1";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "06d85fgcsmgrzhmzxbsnhqn9nnfz4k14wl6s9r3d6hmajx5n3nbm";
  };

  modSha256 = "1sfhnd7l80q8d3wj33phblkd9q51sw7xv4shl2mbch2492lmcs6n";

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
