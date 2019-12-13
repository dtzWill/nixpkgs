{ stdenv, buildGoModule, fetchFromGitHub
, gpgme, libgpgerror, lvm2, btrfs-progs, pkgconfig, ostree, libselinux, libseccomp
}:

buildGoModule rec {
  pname = "buildah";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner  = "containers";
    repo   = "buildah";
    rev    = "v${version}";
    sha256 = "0lsjsfp6ls38vlgibbnsyd1m7jvmjwdmpyrd0qigp4aa2abwi4dg";
  };

  modSha256 = "0xmwp3id5h2b749gyy3y2ihq9b5gxz8zj7l2ybdvjl3w4x4imxkl";

  outputs = [ "bin" "man" "out" ];

  goPackagePath = "github.com/containers/buildah";
  excludedPackages = [ "tests" ];

  # Disable module-mode, because Go 1.13 automatically enables it if there is
  # go.mod file. Remove after https://github.com/NixOS/nixpkgs/pull/73380
  GO111MODULE = "off";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gpgme libgpgerror lvm2 btrfs-progs ostree libselinux libseccomp ];

  patches = [ ./disable-go-module-mode.patch ];

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
