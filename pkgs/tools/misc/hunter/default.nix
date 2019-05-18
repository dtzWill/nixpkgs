{ stdenv, fetchFromGitHub, rustPlatform, file }:

with rustPlatform;

buildRustPackage rec {
  pname = "hunter";
  version = "1.1.3";

  cargoSha256 = "1r0vlpy682y5ydckkhjganby4qzz3kv469yvd3346q0ckqk5x6xx";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qg55s7r4wb0c7ancnnq1rmymijav99ch2xvhgh5dcksar0kp2hb";
  };

  buildInputs = [ file /* libmagic */];

  HOME = ".";

#  postInstall = ''
#    mkdir -p $out/share/man/man1
#    cp contrib/man/exa.1 $out/share/man/man1/
#
#    mkdir -p $out/share/bash-completion/completions
#    cp contrib/completions.bash $out/share/bash-completion/completions/exa
#
#    mkdir -p $out/share/fish/vendor_completions.d
#    cp contrib/completions.fish $out/share/fish/vendor_completions.d/exa.fish
#
#    mkdir -p $out/share/zsh/site-functions
#    cp contrib/completions.zsh $out/share/zsh/site-functions/_exa
#  '';

  # Some tests fail, but Travis ensures a proper build
  #doCheck = false;

  ## TODO: ## meta = with stdenv.lib; {
  ## TODO: ##   description = "Replacement for 'ls' written in Rust";
  ## TODO: ##   longDescription = ''
  ## TODO: ##     exa is a modern replacement for ls. It uses colours for information by
  ## TODO: ##     default, helping you distinguish between many types of files, such as
  ## TODO: ##     whether you are the owner, or in the owning group. It also has extra
  ## TODO: ##     features not present in the original ls, such as viewing the Git status
  ## TODO: ##     for a directory, or recursing into directories with a tree view. exa is
  ## TODO: ##     written in Rust, so it’s small, fast, and portable.
  ## TODO: ##   '';
  ## TODO: ##   homepage = https://the.exa.website;
  ## TODO: ##   license = licenses.mit;
  ## TODO: ##   maintainers = [ maintainers.ehegnes ];
  ## TODO: ## };
}
