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

  postConfigure = ''
    patchShebangs .
    sed -i 's|defaultEnv := "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"|defaultEnv := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' cmd/internal/cli/singularity.go

    ./mconfig -V ${version} -p $bin --localstatedir=/var
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
    make -C builddir install LOCALSTATEDIR=$bin/var
    chmod 755 $bin/libexec/singularity/bin/starter-suid
  '';

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
