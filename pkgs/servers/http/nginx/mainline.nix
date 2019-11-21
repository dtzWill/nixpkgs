{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.17.6";
  sha256 = "1dipq90h3n1xdslwbijwlhbk84r7q0bswlbvi970may09lqsbd1w";
})

