{ callPackage, fetchpatch, boost16x, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.10"; # 2.11.0 causes build neopg failure, TODO: investigate
  revision = "0";
  sha256 = "0cddf64ckfq333a63rfzkv4mk7rxsh86d9zy4i3r49wcaybijj48";
  ext = "tgz";
  # 2.11 moves to tar.xz
  #ext = "tar.xz";
  extraConfigureFlags = [
    "--with-boost"
    "--with-lzma"
    "--with-sqlite3"
    "--with-os-features=getentropy"
  ];
  gmp = null; # removed in 1.11.10, see 9faceec939b2a00043720f07f49e9fee22c60984 for example
  boost = boost16x; # boost 1.70+ not supported until 2.11

  patches = [
    # Fix getentropy include
    (fetchpatch {
      url = "https://github.com/randombit/botan/commit/02aee1fb53dae4439c14f113b2963711890cbde0.patch";
      sha256 = "09zr7qa1ccz6r5myjlxi2mrxsa8xjvx92fxplad0gcd0g148a57g";
    })
  ];
})
