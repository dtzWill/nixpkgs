{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "src-d";
    repo = pname;
    rev = "v${version}";
    sha256 = "10dc7ra37bj107f4fvlprph2i0af0ma31d5alwz6h9dm3pdpk7xs";
  };

  modSha256 = "1qidp8y5k1yi68rgm9m678c5kzqd3hxl8hrk32qvw901wm6daz5s";

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/src-d/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}
