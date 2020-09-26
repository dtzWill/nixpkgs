{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "1y27cc818099drccqg57nq4kcgl2zmg6akxv2k1c8rkz932q718f";
  };

  #vendorSha256 = "1aj7rxlylgvxdnnfnfzh20v2jvs8falvjjishxd8rdk1jgfpipl8";
  # old fetcher :(
  modSha256 = "11xy3avalgrqxk6bgra509gxip7ls2gsx27fahk9fbvq80dyc9c3";

  meta = with stdenv.lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
