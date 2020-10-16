{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "duf";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "duf";
    rev = "v${version}";
    sha256 = "093kir1zwpkl0jic4p1f032ir5k7kra94di2indzn0fa4j4r7a0i";
  };

  #vendorSha256 = "1aj7rxlylgvxdnnfnfzh20v2jvs8falvjjishxd8rdk1jgfpipl8";
  # old fetcher :(
  modSha256 = "1mn22p1ndlh9yjkdqz83kq71y53sispx52qmgbr96q74gnkdnq8d";

  meta = with stdenv.lib; {
    homepage = "https://github.com/muesli/duf/";
    description = "Disk Usage/Free Utility";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ petabyteboy ];
  };
}
