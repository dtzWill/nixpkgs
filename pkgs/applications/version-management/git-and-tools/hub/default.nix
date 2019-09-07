{ stdenv, buildGoModule, fetchFromGitHub, groff, Security, utillinux }:

buildGoModule rec {
  pname = "hub";
  version = "2.12.3";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "13l4nc3k6vl9x1x0153mwi351j3z266wx0fp7xw2851avrgkk9zg";
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

  modSha256 = "05pkcm68i6ig4jhz70sj3gq1vk7xp27cvl0sixys3dsg9krrm0y3";

  meta = with stdenv.lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    license = licenses.mit;
    homepage = https://hub.github.com/;
    maintainers = with maintainers; [ the-kenny globin ];
    platforms = with platforms; unix;
  };
}
