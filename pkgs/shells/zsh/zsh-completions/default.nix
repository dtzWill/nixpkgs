{ stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "zsh-completions-${version}";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-completions";
    rev = "${version}";
    sha256 = "0rw23m8cqxhcb4yjhbzb9lir60zn1xjy7hn3zv1fzz700f0i6fyk";
  };

  installPhase= ''
    install -D --target-directory=$out/share/zsh/site-functions src/*
  '';

  meta = {
    description = "Additional completion definitions for zsh";
    homepage = https://github.com/zsh-users/zsh-completions;
    license = stdenv.lib.licenses.free;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.olejorgenb ];
  };
}
