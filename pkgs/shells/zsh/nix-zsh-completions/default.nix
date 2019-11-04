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
    rev = "26a9a0f8cf5cfe5ca84dd682675c853192a2cfc5";
    sha256 = "06cv59112b5wbz05ndpcih7n32q1vdvfb5zxrsp62lx06jd3wh9j";
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
