{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-actions-cache";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "actions";
    repo = "gh-actions-cache";
    rev = "v${version}";
    sha256 = "sha256-LOEx1is83sBSFC+NwP0503yzxNUhbvMt8mgezMZEfa4=";
  };

  vendorSha256 = "sha256-i9akQ0IjH9NItjYvMWLiGnFQrfZhA7SOvPZiUvdtDrk=";

  ldflags = [ "-s" "-w" ];

  doCheck = false; # tries to access github.com

  meta = {
    description = "gh extension to manage GitHub Action caches";
    homepage = "https://github.com/actions/gh-actions-cache";
    changelog = "https://github.com/actions/gh-actions-cache/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dtzWill ];
  };
}

