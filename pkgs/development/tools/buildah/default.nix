{ stdenv, buildGoModule, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "09bfv2pypd66dnqvrhgcg35fsahi2k0kn5dnnbfqc39g0vfz29r7";
  };

  modSha256 = "0xmwp3id5h2b749gyy3y2ihq9b5gxz8zj7l2ybdvjl3w4x4imxkl";

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  buildPhase = ''
    pushd go/src/${goPackagePath}
    make GIT_COMMIT="unknown"
    install -Dm755 buildah $bin/bin/buildah
  '';

  postBuild = ''
    make -C docs install PREFIX="$man"
  '';

  meta = with stdenv.lib; {
    description = "A tool which facilitates building OCI images";
    homepage = "https://github.com/containers/buildah";
    license = licenses.asl20;
    maintainers = with maintainers; [ Profpatsch vdemeester saschagrunert ];
  };
}
