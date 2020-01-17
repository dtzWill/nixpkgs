{ stdenv, buildGoModule, fetchFromGitHub, groff, Security, utillinux }:

buildGoModule rec {
  pname = "hub";
  version = "unstable-2019-12-31";
  lastversion = "2.13.0";

  goPackagePath = "github.com/github/hub";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    #rev = "v${version}";
    rev = "b7b4a3df1de5ec4a21de769bdb77d57c32b53523";
    sha256 = "0q632aid7p0j9galkp226nvp0k38zjcgyn8pc2pjchvk1sm62ba9";
  };

  nativeBuildInputs = [ groff utillinux ];
  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  postPatch = ''
    patchShebangs .

    # patch in version info
    substituteInPlace version/version.go \
      --replace 'Version = "${lastversion}"' \
                'Version = "${lastversion}-${version}"'
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
