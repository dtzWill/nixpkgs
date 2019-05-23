{ stdenv, fetchFromGitHub, rustPlatform
, file
, glib, gst_all_1
, wrapGAppsHook # to setup GST_* paths, a bit overkill perhaps
}:

with rustPlatform;

buildRustPackage rec {
  pname = "hunter";
  version = "1.2.0";

  cargoSha256 = "0fhkav9y35jfmkqyrgzp6gh9fb5gy8zgc4m99k4sngba0abb8p3z";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j7afn73lg68k4lzpm8dis8mlnrkfm15cvli2s0dk5s29lj9vmck";
  };

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [
    file /* libmagic */
    glib
  ] ++ builtins.attrValues { inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good; };

  HOME = ".";

  doCheck = false; # src/icon.rs doesn't build, references 'Theme' enum not anywhere

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
