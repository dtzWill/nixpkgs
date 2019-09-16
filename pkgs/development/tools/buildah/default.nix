{ stdenv, buildGoModule, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "0yc8chnyh73ndwxr3saif5va4cnrwrx1i3q80yijfimawxpifffa";
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
    maintainers = with maintainers; [ Profpatsch vdemeester ];
  };
}
