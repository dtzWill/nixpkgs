{ stdenv, fetchFromGitHub, libarchive, iucode-tool }:

let
  version = "20190918";
  srcs = {
    official = fetchFromGitHub {
      owner = "intel";
      repo = "Intel-Linux-Processor-Microcode-Data-Files";
      rev = "microcode-${version}";
      sha256 = "0v668mfqxn6wzyng68aqaffh75gc215k13n6d5g7zisivvv2bgdp";
    };
    extracted = fetchFromGitHub {
      owner = "platomav";
      repo = "CPUMicrocodes";
      rev = "9c82fd72cc5bc015d25ddbff00042e11350bdc38"; # 2019-09-14
      sha256 = "0545i68l9mwkjc6x9dx6arc7fh0qki3xfl0ayszjgk92fsxzx862";
    };
  };
in stdenv.mkDerivation rec {
  pname = "microcode-intel";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ iucode-tool libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin \
      ${srcs.official}/intel-ucode/ \
      ${srcs.extracted}/Intel --ignore-broken
    echo kernel/x86/microcode/GenuineIntel.bin | bsdcpio -o -H newc -R 0:0 > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
  };
}
