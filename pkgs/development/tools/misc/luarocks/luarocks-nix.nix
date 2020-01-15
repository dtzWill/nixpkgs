{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2020-01-15";
  src = fetchFromGitHub {
    owner = "dtzWill";
    repo = "luarocks";
    rev = "79f73945d8b9846848da417d970b5dcd4964644a";
    sha256 = "08fw71qz5cpry9i9akr3pjhzpmz0c06yqf1pal6drdcgylirz8y7";
  };
  patches = [
    ./darwin-3.1.3.patch
  ];
})
