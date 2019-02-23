{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  version = "4.19.25";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed

  # branchVersion needs to be x.y
  extraMeta.branch = concatStrings (intersperse "." (take 2 (splitString "." version)));

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0ccpj57pv2rw78a4j5mg9sz7a37k0sn5glbn2rs6yvp9ss81vivy";
  };
} // (args.argsOverride or {}))
