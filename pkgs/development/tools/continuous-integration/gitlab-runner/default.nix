{ lib, buildGoPackage, fetchFromGitLab, fetchurl }:

let
  version = "12.4.1";
  # Gitlab runner embeds some docker images these are prebuilt for arm and x86_64
  docker_x86_64 = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-x86_64.tar.xz";
    sha256 = "0y68x5hl2gip7bpcgjychf5qd1535ry4qkjb3fybm2pb81qy2gy7";
  };

  docker_arm = fetchurl {
    url = "https://gitlab-runner-downloads.s3.amazonaws.com/v${version}/helper-images/prebuilt-arm.tar.xz";
    sha256 = "1nb0cspjqasyg7bppyrf3m3rg1c26iaw6h9dpnq2m7f60dciyiq2";
  };
in
buildGoPackage rec {
  inherit version;
  name = "gitlab-runner-${version}";
  goPackagePath = "gitlab.com/gitlab-org/gitlab-runner";
  commonPackagePath = "${goPackagePath}/common";
  buildFlagsArray = ''
    -ldflags=
      -X ${commonPackagePath}.NAME=gitlab-runner
      -X ${commonPackagePath}.VERSION=${version}
      -X ${commonPackagePath}.REVISION=v${version}
  '';

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    sha256 = "1smn7b1dvqvaka23a7zhnlnpbqw40hpdn8vvj1r3ivx20khpsnhn";
  };

  patches = [ ./fix-shell-path.patch ];

  postInstall = ''
    touch $bin/bin/hello
    install -d $bin/bin/helper-images
    ln -sf ${docker_x86_64} $bin/bin/helper-images/prebuilt-x86_64.tar.xz
    ln -sf ${docker_arm} $bin/bin/helper-images/prebuilt-arm.tar.xz
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = https://about.gitlab.com/gitlab-ci/;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ bachp zimbatm globin ];
  };
}
