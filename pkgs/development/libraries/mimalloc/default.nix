{ stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "1.4.0";
  ver = stdenv.lib.versions.majorMinor version;

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "0n0xl8lccmnm5hwilli6szx14zpwjfppm7mkda91aj9f69r56ah3";
  };

  nativeBuildInputs = [ cmake ninja ];
  enableParallelBuilding = true;
  cmakeFlags = stdenv.lib.optional secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = ''
    # first, install headers, that's easy
    mkdir -p $dev
    mv $out/lib/*/include $dev/include

    # move .a and .o files into place
    mv $out/lib/mimalloc-${ver}/libmimalloc*.a           $out/lib/libmimalloc.a
    mv $out/lib/mimalloc-${ver}/mimalloc*.o              $out/lib/mimalloc.o

  '' + (if secureBuild then ''
    mv $out/lib/mimalloc-${ver}/libmimalloc-secure${soext}.${ver} $out/lib/libmimalloc-secure${soext}.${ver}
    ln -sfv $out/lib/libmimalloc-secure${soext}.${ver} $out/lib/libmimalloc-secure${soext}
    ln -sfv $out/lib/libmimalloc-secure${soext}.${ver} $out/lib/libmimalloc${soext}
  '' else ''
    mv $out/lib/mimalloc-${ver}/libmimalloc${soext}.${ver} $out/lib/libmimalloc${soext}.${ver}
    ln -sfv $out/lib/libmimalloc${soext}.${ver} $out/lib/libmimalloc${soext}
  '') + ''
    # remote duplicate dir. FIXME: try to fix the .cmake file distribution
    # so we can re-use it for dependencies...
    rm -rf $out/lib/mimalloc-${ver}
  '';

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Compact, fast, general-purpose memory allocator";
    homepage    = "https://github.com/microsoft/mimalloc";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
