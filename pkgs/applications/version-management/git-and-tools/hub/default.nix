{ stdenv, buildGoModule, fetchFromGitHub, groff, Security, utillinux }:

buildGoModule rec {
  pname = "hub";
  version = "2.14.1";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b179sp8z2blzh4a0c2pjbbiya68x2i4cnmcci58r8k0mwrx6mw1";
  };

  nativeBuildInputs = [ groff utillinux ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    patchShebangs .
  '';

  postInstall = ''
    install -D etc/hub.zsh_completion "$out/share/zsh/site-functions/_hub"
    install -D etc/hub.bash_completion.sh "$out/share/bash-completion/completions/hub"
    install -D etc/hub.fish_completion  "$out/share/fish/vendor_completions.d/hub.fish"

    LC_ALL=C.UTF8 \
    make man-pages
    cp -vr --parents share/man/man[1-9]/*.[1-9] $out/
  '';

  # XXX: depends on go version?! D:
  modSha256 = "1512kiiwb3bli7vj5cmrfa10h29g9xphsd336krwqg3gmq0gpaxj";

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny globin ];
    platforms = with platforms; unix;
  };
}
