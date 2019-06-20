{stdenv
, removeReferencesTo
, lib
, fetchFromGitHub
, utillinux
, pkgconfig
, openssl
, gpgme
, libseccomp
, coreutils
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

  outputs = [ "bin" "out" ];

  postConfigure = ''
    patchShebangs .
    sed -i 's|defaultPath := "[^"]*"|defaultPath := "${stdenv.lib.makeBinPath propagatedBuildInputs}"|' cmd/internal/cli/actions.go

    ./mconfig \
      -V ${version} \
      -P release \
      --prefix=$out \
      --localstatedir=/var \
      --without-suid
    touch builddir/.dep-done
    touch builddir/vendors-done

    # TODO: How does this (and minor supporting bits elsewhere) compare to --disable-suid config flag?
    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

    # Point to base gopath
    sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $NIX_BUILD_TOP/vendor/github.com/containernetworking/plugins/plugins|" builddir/Makefile
  '';

  makeFlags = [ "-C" "builddir" ];

  installFlags = [ "LOCALSTATEDIR=$bin/var" ];
  postInstall = ''
    chmod 755 $bin/libexec/singularity/bin/starter-suid
    wrapProgram $bin/bin/singularity --prefix PATH : ${stdenv.lib.makeBinPath propagatedBuildInputs}
  '';

  postFixup = ''
    find $out/ -type f -executable -exec remove-references-to -t ${go} '{}' + || true

    # These etc scripts shouldn't have their paths patched
    cp etc/actions/* ''${!outputBin}/etc/singularity/actions/

    for x in ''${!outputBin}/bin/*; do
      wrapProgram $x --prefix PATH : ${getBin squashfsTools}/bin
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.sylabs.io/;
    description = "Application containers for linux";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.jbedo ];
  };
}
