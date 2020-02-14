{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "peco";
  version = "0.5.6";

  goPackagePath = "github.com/peco/peco";
  subPackages = [ "cmd/peco" ];

  src = fetchFromGitHub {
    owner = "peco";
    repo = "peco";
    rev = "v${version}";
    sha256 = "1v0k7w8qhqqaxnavn8sgv1qxz1axfgs9m5zj0m3mzybv5i5xpab5";
  };

  modSha256 = "1djba504z5lj8w4cfshk6ai3fd8gn1jzfp6aiwdzlg81356d430m";

  meta = with stdenv.lib; {
    description = "Simplistic interactive filtering tool";
    homepage = https://github.com/peco/peco;
    license = licenses.mit;
    # peco should work on Windows or other POSIX platforms, but the go package
    # declares only linux and darwin.
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
  };
}
