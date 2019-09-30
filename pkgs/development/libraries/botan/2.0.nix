{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.11";
  revision = "0";
  sha256 = "1gllh0zgp0qyk464k2amdyv91gvrg09v4h6zfzyiih5qmsi4v1zp";
  ext = "tar.xz";
})
