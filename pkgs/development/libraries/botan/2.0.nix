{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.11";
  revision = "0";
  sha256 = "1gllh0zgp0qyk464k2amdyv91gvrg09v4h6zfzyiih5qmsi4v1zp";
  ext = "tar.xz";
  extraConfigureFlags = [ "--with-boost" "--with-lzma" "--with-sqlite3" "--with-tpm" ];
  gmp = null; # removed in 1.11.10, see 9faceec939b2a00043720f07f49e9fee22c60984 for example

  patches = [
    # Fix getentropy include
    (fetchpatch {
      url = "https://github.com/randombit/botan/commit/02aee1fb53dae4439c14f113b2963711890cbde0.patch";
      sha256 = "09zr7qa1ccz6r5myjlxi2mrxsa8xjvx92fxplad0gcd0g148a57g";
    })
  ];
})
