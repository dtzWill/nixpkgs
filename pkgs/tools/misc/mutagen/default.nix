{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "18wjzylxypvisfdmmwqc8g9vd9w7iyhs8irad1ksf7fhwz9w188m";
  };

  modSha256 = "0xbs3sjb0v7rgfgvxdlpfj4z147pvbrmmn8khpz8cz1mnzf34y7h";

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

  meta = with lib; {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
