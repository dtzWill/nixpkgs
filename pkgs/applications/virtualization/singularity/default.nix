{stdenv
, removeReferencesTo
, lib
, fetchgit
, fetchFromGitHub
, utillinux
, openssl
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

  buildInputs = [ openssl ];
  nativeBuildInputs = [ removeReferencesTo utillinux which makeWrapper ];
  propagatedBuildInputs = [ coreutils squashfsTools ];

  postPatch = ''
    # FWIW and since it may be easy to miss:
    # The paths in these files aren't quite identical but they're close :).
    # In particular the defaultPath in the first substitution is different
    # than the matching value found in the next two files.
    # All variations are replaced with the same new value, however.
    substituteInPlace cmd/internal/cli/actions.go \
      --replace 'defaultPath = "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"' \
                'defaultPath = "${stdenv.lib.makeBinPath propagatedBuildInputs}"'
    # Errr this is in my git clone but not in build? Bah, trace down post-releases reorg later/soon
    ##substituteInPlace e2e/env/env.go \
    ##  --replace 'defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
    ##            'defaultPath = "${stdenv.lib.makeBinPath propagatedBuildInputs}"'
    substituteInPlace cmd/singularity/env_test.go \
      --replace 'defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
                'defaultPath = "${stdenv.lib.makeBinPath propagatedBuildInputs}"'
  '';

  postConfigure = ''
    patchShebangs .

    ./mconfig \
      -V ${version} \
      -p ''${!outputBin} \
      --localstatedir=/var \
      --without-suid
  ##  touch builddir/.dep-done
  ##  touch builddir/vendors-done

  ##  # Point to base gopath
  ##  sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $NIX_BUILD_TOP/vendor/github.com/containernetworking/plugins/plugins|" builddir/Makefile
  '';

#  buildPhase = ''
#    make -C builddir
#  '';
#
#  installPhase = ''
#    make -C builddir install LOCALSTATEDIR=$bin/var
#    chmod 755 $bin/libexec/singularity/bin/starter-suid
#  '';

  postFixup = ''
    find $bin/ -type f -executable -exec remove-references-to -t ${go} '{}' + || true

    # These etc scripts shouldn't have their paths patched
    cp etc/actions/* $bin/etc/singularity/actions/
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sylabs.io/;
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
