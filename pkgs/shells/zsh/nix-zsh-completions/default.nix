{ stdenv, fetchFromGitHub }:

let
  version = "0.4.3";
in

stdenv.mkDerivation rec {
  name = "nix-zsh-completions-${version}";

  src = fetchFromGitHub {
    owner = "spwhitt";
    repo = "nix-zsh-completions";
    #rev = "${version}";
    rev = "adbf7bf6dd01f2410700fa51cdb31346c8108318";
    sha256 = "0xz8m12hgf8vrjdswwjs3gqyyw53f0vq9z9i0ssfc3zmgcwnsa3r";
  };

  installPhase = ''
    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/spwhitt/nix-zsh-completions;
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt olejorgenb hedning ma27 ];
  };
}
