{ stdenv, fetchurl, nasm }:

stdenv.mkDerivation rec {
  pname = "x264";
  version = "20190912-2245";

  src = fetchurl {
    url = "https://download.videolan.org/x264/snapshots/x264-snapshot-${version}-stable.tar.bz2";
    sha256 = "06kphlclfwv166ncfm1dwbxbi1b5g202mqw2yn7l4nlsm4svxkiy";
  };

  postPatch = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  outputs = [ "out" "lib" "dev" ];

  preConfigure = ''
    # `AS' is set to the binutils assembler, but we need nasm
    unset AS
  '';

  configureFlags = [ "--enable-shared" ]
    ++ stdenv.lib.optional (!stdenv.isi686) "--enable-pic";

  nativeBuildInputs = [ nasm ];

  meta = with stdenv.lib; {
    description = "Library for encoding H264/AVC video streams";
    homepage    = http://www.videolan.org/developers/x264.html;
    license     = licenses.gpl2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ spwhitt tadeokondrak ];
  };
}
