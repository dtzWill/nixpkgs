{ luarocks, fetchFromGitHub }:
luarocks.overrideAttrs(old: {
  pname = "luarocks-nix";
  version = "2020-01-15";
  src = fetchFromGitHub {
    owner = "dtzWill"; # "teto";
    repo = "luarocks";
    rev = "d0cad2d1deb90bf13e0fd30552b16e245a6aa3b5";
    sha256 = "0kziwfw5gqq5xsckl7qf9wasaiy8rp42h5qrcnjx07qp47a9ldx7";
  };
  patches = [
    ./darwin-3.1.3.patch
  ];
})
