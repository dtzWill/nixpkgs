{ stdenv, fetchFromGitHub, cmake, ninja
, secureBuild ? false
}:

let
  soext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname   = "mimalloc";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner  = "microsoft";
    repo   = pname;
    rev    = "refs/tags/v${version}";
    sha256 = "03xvg911gpci4ayd37cl3i8gf4sr9mrdsla4ckw1npz9r3q06c65";
  };

  nativeBuildInputs = [ cmake ninja ];
  enableParallelBuilding = true;
  cmakeFlags = stdenv.lib.optional secureBuild [ "-DMI_SECURE=ON" ];

  postInstall = ''
    # first, install headers, that's easy
    mkdir -p $dev
    mv $out/lib/*/include $dev/include

    # move .a and .o files into place
    mv $out/lib/mimalloc-1.3/libmimalloc*.a           $out/lib/libmimalloc.a
    mv $out/lib/mimalloc-1.3/mimalloc*.o              $out/lib/mimalloc.o

  '' + (if secureBuild then ''
    mv $out/lib/mimalloc-1.3/libmimalloc-secure${soext}.1.3 $out/lib/libmimalloc-secure${soext}.1.3
    ln -sfv $out/lib/libmimalloc-secure${soext}.1.3 $out/lib/libmimalloc-secure${soext}
    ln -sfv $out/lib/libmimalloc-secure${soext}.1.3 $out/lib/libmimalloc${soext}
  '' else ''
    mv $out/lib/mimalloc-1.3/libmimalloc${soext}.1.3 $out/lib/libmimalloc${soext}.1.3
    ln -sfv $out/lib/libmimalloc${soext}.1.3 $out/lib/libmimalloc${soext}
  '') + ''
    # remote duplicate dir. FIXME: try to fix the .cmake file distribution
    # so we can re-use it for dependencies...
    rm -rf $out/lib/mimalloc-1.3
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
