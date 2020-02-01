{ stdenv, fetchFromGitHub, pkgconfig, zlib, cmake, jemalloc }:

stdenv.mkDerivation rec {
  pname = "lwan";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "lpereira";
    repo = pname;
    rev = "v${version}";
    sha256 = "1znkcsbxw3r10prqvf2x27w1wmm9kd485pj59c364wlvqdhidwqr";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ jemalloc zlib ];

  # Note: tcmalloc and mimalloc are also supported (and normal malloc)
  cmakeFlags = [ "-DUSE_ALTERNATIVE_MALLOC=jemalloc" ];

  # Workaround bad detection of secure_getenv, a recent musl addition.
  # This breaks the build as they provide their own definition which conflicts.
  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.hostPlatform.isMusl "-DHAVE_SECURE_GETENV=1";

  meta = with stdenv.lib; {
    description = "Lightweight high-performance multi-threaded web server";
    longDescription = "A lightweight and speedy web server with a low memory
      footprint (~500KiB for 10k idle connections), with minimal system calls and
      memory allocation.  Lwan contains a hand-crafted HTTP request parser. Files are
      served using the most efficient way according to their size: no copies between
      kernel and userland for files larger than 16KiB.  Smaller files are sent using
      vectored I/O of memory-mapped buffers. Header overhead is considered before
      compressing small files.  Features include: mustache templating engine and IPv6
      support.
    ";
    homepage = "https://lwan.ws/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
