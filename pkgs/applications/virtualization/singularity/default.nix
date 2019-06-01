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


  postConfigure = ''
    patchShebangs .

    ./mconfig \
      -V ${version} \
      -P release \
      --prefix=$out \
      --localstatedir=/var
    touch builddir/.dep-done
    touch builddir/vendors-done

    # TODO: How does this compare to --disable-suid config flag?
    # Don't install SUID binaries
    sed -i 's/-m 4755/-m 755/g' builddir/Makefile

    # Point to base gopath
    sed -i "s|^cni_vendor_GOPATH :=.*\$|cni_vendor_GOPATH := $NIX_BUILD_TOP/vendor/github.com/containernetworking/plugins/plugins|" builddir/Makefile

    # Set path for mksquashfs, which admin will replace/set if needed anyway.
    # There really appears to be mechanisms to set these values (at multiple levels!)
    # but I can't seem to find any way to actually do so.
    # Since I don't know how to integrate this in a more natural way,
    # make this substitution as direct and clearly not doing something clever.
    # As an aside: note that the name "location" used in the example variables and
    # the example configuration line given above (not shown here, in the file)
    # appears to not actually be what the parser recognizes, which is "path".
    # This is relevant for the substitution below, but may be expected or obvious
    # with the context I seem to be missing.  Anyway, just wanted to note it :).
    substituteInPlace etc/singularity.conf.in \
      --replace '@MKSQUASHFS_LOCATION@ = @MKSQUASHFS_LOCATION_DEFAULT@' \
                'mksquashfs location = ${squashfsTools}/bin/mksquashfs'

    cat etc/singularity.conf.in
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
