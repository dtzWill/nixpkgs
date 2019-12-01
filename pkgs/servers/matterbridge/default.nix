{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "matterbridge";
  version = "1.16.2";

  goPackagePath = "github.com/42wim/matterbridge";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0cddm9vnismiifcgc13p4r6bdwvk7l9q1cxksp7v14w0x24jyb91";
  };

  modSha256 = "1fvwx1wks4brw314z6kl3wn117qg239phzxhzxgqzmvk4x26c4bp";

  meta = with stdenv.lib; {
    description = "Simple bridge between Mattermost, IRC, XMPP, Gitter, Slack, Discord, Telegram, Rocket.Chat, Hipchat(via xmpp), Matrix and Steam";
    homepage = https://github.com/42wim/matterbridge;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
