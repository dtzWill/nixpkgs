{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "0cgzvzdsy8vbiapgk1l5dp48c3kq0xmx53yfi486mx8nwvz3ksc0";
  };

  cargoSha256 = "1pf5xs94za57bgw2skbc6d517mxxhj2yizx8wfp4xbgdxqbs6gdy";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
