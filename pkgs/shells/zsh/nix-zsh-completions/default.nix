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
    rev = "23cbcf53fa259a23bb56d3641c70cc815f8e9b8f";
    sha256 = "1zqa8ilwzisz8ic8bnyg6xxgrwaqdlw9cpfk7d4qxh49lfbx7p52";
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
