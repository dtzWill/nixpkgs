{stdenv
, removeReferencesTo
, lib
, fetchgit
, fetchFromGitHub
, utillinux
, pkgconfig
, openssl
, gpgme
, libseccomp
, coreutils
, gawk
, go
, which
, makeWrapper
, squashfsTools
, buildGoModule}:

with lib;

buildGoModule rec {
  pname = "singularity";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "sylabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "14lhxwy21s7q081x7kbnvkjsbxgsg2f181qlzmlxcn6n7gfav3kj";
  };

  goPackagePath = "github.com/sylabs/singularity";

  modSha256 = "05cxirhjbg2lp48wpwiqqklwip3yq8z6hhplikv7zdrqfys9ihyz";

  buildInputs = [ openssl gpgme libseccomp ];
  nativeBuildInputs = [ removeReferencesTo utillinux which makeWrapper pkgconfig ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  #outputs = [ "bin" "out" ];

  postPatch = let path = stdenv.lib.makeBinPath propagatedBuildInputs; in ''
    # FWIW and since it may be easy to miss:
    # The paths in these files aren't quite identical but they're close :).
    # In particular the defaultPath in the first substitution is different
    # than the matching value found in the next two files.
    # All variations are replaced with the same new value, however.
    substituteInPlace cmd/internal/cli/actions.go \
      --replace 'defaultPath = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"' \
                'defaultPath = "${path}"'
    substituteInPlace vendor/github.com/containers/storage/pkg/system/path.go \
      --replace 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' \
                'PATH=${path}'

    substituteInPlace internal/pkg/runtime/engines/singularity/container_linux.go \
      --replace '"/bin:/sbin:/usr/bin:/usr/sbin"' '"${path}"'

    substituteInPlace internal/pkg/util/env/clean.go \
      --replace 'g.AddProcessEnv("PATH", "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin")' \
                'g.AddProcessEnv("PATH", "${path}")'

    substituteInPlace vendor/github.com/opencontainers/runtime-tools/generate/generate.go \
      --replace "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
                "PATH=${path}"

    substituteInPlace vendor/github.com/containers/storage/pkg/system/path.go \
      --replace 'defaultUnixPathEnv = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
                'defaultUnixPathEnv = "${path}"'

    substituteInPlace vendor/github.com/docker/docker/pkg/system/path.go \
      --replace 'defaultUnixPathEnv = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
                'defaultUnixPathEnv = "${path}"'

    substituteInPlace cmd/singularity/env_test.go \
      --replace 'defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
                'defaultPath = "${stdenv.lib.makeBinPath propagatedBuildInputs}"'
  '';

  postConfigure = ''
    patchShebangs .

    ./mconfig \
      -V ${version} \
      -P release-stripped \
      --prefix=$out \
      --localstatedir=/var
    touch builddir/.dep-done
    touch builddir/vendors-done

    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

    # Point to base gopath
    sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $NIX_BUILD_TOP/vendor/github.com/containernetworking/plugins/plugins|" builddir/Makefile
  '';

  buildPhase = ''
    make -C builddir
  '';

installPhase = ''
  make -C builddir install LOCALSTATEDIR=$out/var
  chmod 755 ''${!outputBin}/libexec/singularity/bin/starter-suid
'';

postFixup = ''
  find $out/ -type f -executable -exec remove-references-to -t ${go} '{}' + || true

  # These etc scripts shouldn't have their paths patched
  cp etc/actions/* ''${!outputBin}/etc/singularity/actions/
'';

  meta = with stdenv.lib; {
    homepage = http://www.sylabs.io/;
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
