{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lazydocker";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazydocker";
    rev = "v${version}";
    sha256 = "0h2c1f9r67i6a8ppspsg1ln9rkm272092aaaw55sd15xxr51s4hb";
  };

  modSha256 = "02n0lg28icy11a2j2rrlmp70blby0kmjas5j48jwh9h9a0yplqic";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A simple terminal UI for both docker and docker-compose";
    homepage = https://github.com/jesseduffield/lazydocker;
    license = licenses.mit;
    maintainers = with maintainers; [ das-g ];
  };
}
